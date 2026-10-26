{
  pkgs,
  user,
  ...
}:

# llama.cpp router server for local models, driven by pi's /llama and /model
# commands. The router discovers GGUF files in /Users/${user}/models and loads
# or unloads models on demand -- nothing is loaded at startup.
#
# Model layout (single files directly in the dir, multi-shard/multimodal in
# subdirectories):
#   models/
#   ├── llama-3.2-1b-Q4_K_M.gguf
#   └── large-model-Q4_K_M/
#       ├── large-model-Q4_K_M-00001-of-00003.gguf
#       └── ...
let
  modelsDir = "/Users/${user}/models";

  # The wrapper ensures the models dir exists before the server starts
  # (the server exits immediately if it is missing) and runs as the user,
  # so HF downloads land with correct ownership.
  router = pkgs.writeShellScript "llama-cpp-router" ''
    set -eu
    mkdir -p "${modelsDir}"
    exec ${pkgs.llama-cpp}/bin/llama-server \
      --models-dir "${modelsDir}" \
      --no-models-autoload \
      --jinja \
      --host 127.0.0.1 \
      --port 8080 \
      -ngl 999 \
      -c 32768
  '';
in
{
  launchd.user.agents.llama-cpp = {
    serviceConfig = {
      ProgramArguments = [ (toString router) ];
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";
      StandardOutPath = "/tmp/llama-cpp.log";
      StandardErrorPath = "/tmp/llama-cpp.log";
    };
  };
}
