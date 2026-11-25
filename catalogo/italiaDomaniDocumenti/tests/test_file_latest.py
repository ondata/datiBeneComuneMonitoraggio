import csv
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / 'script' / 'italiaDomaniDocumenti.sh'
BASE = 'https://www.italiadomani.gov.it'
HTML = '''<!DOCTYPE html>
<html><body><div class="documentssearch">
  <div data-cmp-hook-search="wrapper">
    <div class="card" data-date="11/09/26">
      <div><h4><button><span>Linee guida Sintesi delle irregolarità</span></button></h4></div>
      <div class="collapse"><div class="card-body pt-0">
        <div class="description-document">Descrizione</div>
        <div class="document-download"><a class="btn-download" href="/content/dam/nota.pdf">Scarica nota</a></div>
        <div class="document-download"><a class="btn-download" href="/content/dam/linee%20guida.pdf">Scarica linee guida</a></div>
        <div class="document-download"><a class="btn-download" href="/content/dam/format-spese.pdf">Scarica format spese</a></div>
        <div class="document-download"><a class="btn-download" href="https://example.org/format-registro.pdf">Scarica format registro</a></div>
        <div class="link-document"><a href="/schede/linee-guida.html">Apri</a></div>
      </div></div>
    </div>
  </div>
  <div data-cmp-hook-search="wrapper">
    <div class="card" data-date="10/09/26">
      <div><h4><button><span>Altro documento</span></button></h4></div>
      <div class="collapse"><div class="card-body pt-0">
        <div class="description-document">Descrizione</div>
        <div class="document-download"><a class="btn-download" href="/content/dam/altro.pdf">Scarica</a></div>
        <div class="link-document"><a href="/schede/altro.html">Apri</a></div>
      </div></div>
    </div>
  </div>
  <div data-cmp-hook-search="wrapper">
    <div class="card" data-date="09/09/26">
      <div><h4><button><span>Scheda senza allegati</span></button></h4></div>
      <div class="collapse"><div class="card-body pt-0">
        <div class="description-document">Descrizione</div>
        <div class="link-document"><a href="/schede/senza-allegati.html">Apri</a></div>
      </div></div>
    </div>
  </div>
</div></body></html>
'''


class FileLatestTest(unittest.TestCase):
    def test_one_row_per_attachment_of_the_correct_document(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            script = root / 'script' / SCRIPT.name
            script.parent.mkdir()
            shutil.copyfile(SCRIPT, script)
            fixture = root / 'fixture.html'
            fixture.write_text(HTML, encoding='utf-8')

            bin_dir = root / 'bin'
            bin_dir.mkdir()
            for name, body in [('git', 'exit 0'), ('google-chrome-stable', 'cat "$TEST_HTML"')]:
                command = bin_dir / name
                command.write_text(f'#!/bin/sh\n{body}\n', encoding='utf-8')
                command.chmod(0o755)
            env = {**os.environ, 'PATH': f'{bin_dir}:{os.environ["PATH"]}', 'TEST_HTML': str(fixture)}
            result = subprocess.run(['bash', str(script)], cwd=root, env=env,
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

            with (root / 'output' / 'file_latest.csv').open(encoding='utf-8', newline='') as f:
                actual = [(r['title'], r['datetime'], r['URLfile']) for r in csv.DictReader(f)]

        title = 'Linee guida Sintesi delle irregolarità'
        self.assertCountEqual(actual, [
            (title, '2026-09-11', f'{BASE}/content/dam/nota.pdf'),
            (title, '2026-09-11', f'{BASE}/content/dam/linee%20guida.pdf'),
            (title, '2026-09-11', f'{BASE}/content/dam/format-spese.pdf'),
            (title, '2026-09-11', 'https://example.org/format-registro.pdf'),
            ('Altro documento', '2026-09-10', f'{BASE}/content/dam/altro.pdf'),
        ])


if __name__ == '__main__':
    unittest.main()
