import build as build_

def test(out: build_.BuildOutput) -> bool:
    stdout, stderr, retcode = out['minizinc']
    return stderr.strip(b'\r\n\t ') == b'' 
    