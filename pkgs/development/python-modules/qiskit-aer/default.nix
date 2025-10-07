{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # Build dependencies
  cmake,
  ninja,
  scikit-build,
  # C libraries
  blas,
  nlohmann_json,
  spdlog,
  # Python dependencies
  numpy,
  pybind11,
  psutil,
  python-dateutil,
  qiskit,
  scipy,
  # Test dependencies
  pytestCheckHook,
  ddt,
  fixtures,
  pytest-timeout,
  testtools,
}:
buildPythonPackage rec {
  pname = "qiskit-aer";
  version = "0.17.2";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-aer";
    rev = version;
    hash = "sha256-aVmGoLMnDjV3iB9s4tvcL62zKvH/p70mqeGsxHzi3nc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"conan<2.0.0",' ""
  '';

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
  ];

  buildInputs = [
    blas
    nlohmann_json
    spdlog
  ];

  propagatedBuildInputs = [
    numpy
    pybind11
    psutil
    python-dateutil
    qiskit
    scipy
  ];

  env.DISABLE_CONAN = "1";
  dontUseCmakeConfigure = true;
  doCheck = false;

  pythonImportsCheck = [
    "qiskit_aer"
    "qiskit_aer.backends.aer_simulator"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    fixtures
    pytest-timeout
    testtools
  ];

  disabledTests = [
    "test_clifford"
    "test_approx_random"
    "test_snapshot"
    "test_initialize_2"
    "test_pauli_error_2q_gate_from_string_1qonly"
    "test_kraus_gate_noise"
    "test_backend_method_clifford_circuits_and_kraus_noise"
    "test_backend_method_nonclifford_circuit_and_kraus_noise"
    "test_kraus_noise_fusion"
    "test_paulis_1_and_2_qubits"
    "test_3d_oscillator"
    "_057"
    "_136"
    "_137"
    "_138"
    "_139"
    "_140"
    "_141"
    "_143"
    "_144"
    "test_sparse_output_probabilities"
    "test_reset_2_qubit"
    "test_extended_stabilizer_sparse_output_probs"
  ];

  pytestFlags = [
    "--timeout=30"
    "--durations=10"
  ];

  preCheck = ''
    # Tests include a compiled "circuit" which is auto-built in $HOME
    export HOME=$(mktemp -d)
    # move tests b/c by default try to find (missing) cython-ized code in /build/source dir
    cp -r $TMP/$sourceRoot/test $HOME
    # Add qiskit-aer compiled files to cython include search
    pushd $HOME
  '';

  postCheck = "popd";

  meta = with lib; {
    description = "High performance simulators for Qiskit";
    homepage = "https://qiskit.org/ecosystem/aer";
    downloadPage = "https://github.com/Qiskit/qiskit-aer/releases";
    changelog = "https://github.com/Qiskit/qiskit-aer/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
