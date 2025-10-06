{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-requirements-txt,
  hatchling,
  version-pioneer,
  coloredlogs,
  gitpython,
  persist-queue,
  platformdirs,
  psutil,
  pynvim,
  selenium,
  verboselogs,
  pytest,
  pytest-cov,
  ruff,
  tox,
}:

buildPythonPackage rec {
  pname = "jupynium";
  version = "0.2.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TydqvoODO49WjXdD20GD4ywVLzqaGHUdh07fr0MtuXw=";
  };

  build-system = [
    hatch-requirements-txt
    hatchling
    version-pioneer
  ];

  dependencies = [
    coloredlogs
    gitpython
    persist-queue
    platformdirs
    psutil
    pynvim
    selenium
    verboselogs
  ];

  optional-dependencies = {
    dev = [
      pytest
      pytest-cov
      ruff
      tox
      version-pioneer
    ];
  };

  pythonImportsCheck = [
    "jupynium"
  ];

  meta = {
    description = "Neovim plugin that automates Jupyter Notebook editing/browsing using Selenium";
    homepage = "https://pypi.org/project/jupynium/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DuarteSJ ];
  };
}
