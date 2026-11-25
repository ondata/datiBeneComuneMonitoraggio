import csv
import io
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / 'script'
HEADER = 'titoloFile,dataReport,hrefFile,titoloPagina,url\n'
OLD_URL = 'http://www.salute.gov.it/Epi_Abruzzo_20200922.pdf'
NEW_URL = 'https://www.salute.gov.it/Epi_Lazio_20200923.pdf'
PAGE = 'https://www.salute.gov.it/report.html'
ARCHIVE = HEADER + (
    f'Abruzzo,20200922,{OLD_URL},"report, del 22",{PAGE}\n'
    f'Basilicata,20200922,http://www.salute.gov.it/Epi_Basilicata_20200922.pdf,report,{PAGE}\n'
)
CURL = '''#!/usr/bin/env python3
import os
import sys

if '-w' in sys.argv:
    print('200')
elif 'search?' in sys.argv[-1]:
    count = os.environ['TEST_RESULTS']
    print(f'<div class="portlet-content search-results"><div><div>Ricerca</div><div>Risultati {count}</div></div></div>')
    print('<div class="results"><a href="https://www.salute.gov.it/report.html">uno</a><a href="https://www.salute.gov.it/report2.html">due</a></div>')
else:
    print('<html><head><title>report settimanale</title></head><body><div class="portlet tab-content">')
    print('<a href="https://www.salute.gov.it/Epi_Abruzzo_20200922.pdf">Titolo cambiato</a>')
    print('<a href="https://www.salute.gov.it/Epi_Lazio_20200923.pdf">Lazio</a>')
    print('</div></body></html>')
'''


class AppendTest(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = Path(directory.name)
        self.script = self.root / 'script'
        self.script.mkdir()
        for source in SCRIPT.iterdir():
            if source.suffix in {'.sh', '.py'} and source.is_file():
                shutil.copyfile(source, self.script / source.name)
        output = self.root / 'output'
        output.mkdir()
        self.csv = output / 'monitoraggioSettimanale.csv'
        self.csv.write_bytes(ARCHIVE.encode())
        self.md = output / 'monitoraggioSettimanale.md'
        self.md.write_text('Indice precedente\n', encoding='utf-8')
        self.bin_dir = self.root / 'bin'
        self.bin_dir.mkdir()
        for name, source in [('git', '#!/bin/sh\nexit 0\n'), ('curl', CURL)]:
            path = self.bin_dir / name
            path.write_text(source, encoding='utf-8')
            path.chmod(0o755)

    def run_update(self, results):
        env = {**os.environ, 'PATH': f'{self.bin_dir}:{os.environ["PATH"]}', 'TEST_RESULTS': str(results)}
        result = subprocess.run(['bash', str(self.script / 'monitoraggioSettimanale.sh')],
                                cwd=self.root, env=env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_empty_results_leave_the_archive_untouched(self):
        self.run_update(0)
        self.assertEqual(self.csv.read_bytes(), ARCHIVE.encode())
        self.assertEqual(self.md.read_text(encoding='utf-8'), 'Indice precedente\n')

    def test_partial_results_append_only_new_documents_and_do_not_duplicate(self):
        self.run_update(2)
        updated = self.csv.read_bytes()
        self.assertTrue(updated.startswith(ARCHIVE.encode()), updated.decode())
        rows = list(csv.DictReader(io.StringIO(updated.decode())))
        self.assertEqual(len(rows), 3)
        self.assertEqual(rows[-1]['hrefFile'], NEW_URL)
        self.assertIn('Basilicata', self.md.read_text(encoding='utf-8'))
        self.run_update(2)
        self.assertEqual(self.csv.read_bytes(), updated)


if __name__ == '__main__':
    unittest.main()
