from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]

class PrivacyTest(unittest.TestCase):
    def test_studio_bundle_is_offline(self):
        html = (ROOT / 'dist/NALA-HWSensors.app/Contents/Resources/ui/index.html').read_text()
        self.assertNotIn('fonts.googleapis.com', html)
        self.assertIn("default-src 'none'", html)
        self.assertIn("connect-src 'none'", html)

    def test_bundle_is_agent_and_universal(self):
        import plistlib, subprocess
        root = ROOT / 'dist/NALA-HWSensors.app/Contents'
        info = plistlib.loads((root / 'Info.plist').read_bytes())
        self.assertTrue(info['LSUIElement'])
        arch = subprocess.check_output(['lipo', '-archs', str(root / 'MacOS/NALA-HWSensors')], text=True)
        self.assertTrue({'arm64', 'x86_64'} <= set(arch.split()))

if __name__ == '__main__': unittest.main()
