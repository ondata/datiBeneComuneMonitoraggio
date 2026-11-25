import csv
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit


FIELDS = ('titoloFile', 'dataReport', 'hrefFile', 'titoloPagina', 'url')


def report_key(url):
    parsed = urlsplit(url)
    return parsed.netloc.lower(), unquote(parsed.path), parsed.query


def read_reports(path):
    if not path.exists() or path.stat().st_size == 0:
        return
    with path.open(encoding='utf-8', newline='') as stream:
        reader = csv.DictReader(stream)
        if tuple(reader.fieldnames or ()) != FIELDS:
            raise ValueError(f'Intestazione CSV inattesa: {path}')
        yield from reader


def append_reports(archive, incoming):
    seen = {report_key(row['hrefFile']) for row in read_reports(archive)}
    new_rows = []
    for row in read_reports(incoming):
        if not row['hrefFile']:
            continue
        key = report_key(row['hrefFile'])
        if key not in seen:
            new_rows.append(row)
            seen.add(key)
    if not new_rows:
        return

    has_header = archive.exists() and archive.stat().st_size > 0
    with archive.open('a', encoding='utf-8', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=FIELDS, lineterminator='\n')
        if has_header:
            with archive.open('rb') as existing:
                existing.seek(-1, 2)
                if existing.read(1) not in (b'\n', b'\r'):
                    stream.write('\n')
        else:
            writer.writeheader()
        writer.writerows(new_rows)


if __name__ == '__main__':
    append_reports(*(Path(argument) for argument in sys.argv[1:]))
