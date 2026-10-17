import importlib.machinery
import importlib.util
from pathlib import Path
import unittest


SCRIPT = Path(__file__).parents[1] / "dot_local/bin/executable_noctalia-waydeeper"
loader = importlib.machinery.SourceFileLoader("noctalia_waydeeper", str(SCRIPT))
spec = importlib.util.spec_from_loader(loader.name, loader)
noctalia_waydeeper = importlib.util.module_from_spec(spec)
loader.exec_module(noctalia_waydeeper)


class LayerVisibleTests(unittest.TestCase):
    def test_rejects_transparent_waydeeper_layer(self):
        monitors = [{"name": "DP-9", "width": 1600, "height": 900}]
        layers = {
            "DP-9": {
                "levels": {
                    "0": [
                        {
                            "namespace": "waydeeper",
                            "w": 1600,
                            "h": 900,
                            "alpha": 0,
                        }
                    ]
                }
            }
        }

        self.assertFalse(
            noctalia_waydeeper.layer_visible("DP-9", monitors=monitors, layers=layers)
        )

    def test_rejects_waydeeper_layer_with_wrong_dimensions(self):
        monitors = [{"name": "DP-9", "width": 1600, "height": 900}]
        layers = {
            "DP-9": {
                "levels": {
                    "0": [
                        {
                            "namespace": "waydeeper",
                            "w": 1868,
                            "h": 1080,
                            "alpha": 1,
                        }
                    ]
                }
            }
        }

        self.assertFalse(
            noctalia_waydeeper.layer_visible("DP-9", monitors=monitors, layers=layers)
        )

    def test_accepts_opaque_correctly_sized_waydeeper_layer(self):
        monitors = [{"name": "DP-9", "width": 1600, "height": 900}]
        layers = {
            "DP-9": {
                "levels": {
                    "0": [
                        {
                            "namespace": "waydeeper",
                            "w": 1600,
                            "h": 900,
                            "alpha": 1,
                        }
                    ]
                }
            }
        }

        self.assertTrue(
            noctalia_waydeeper.layer_visible("DP-9", monitors=monitors, layers=layers)
        )


if __name__ == "__main__":
    unittest.main()
