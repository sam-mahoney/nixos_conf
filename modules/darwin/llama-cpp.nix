{ pkgs, user, ... }:

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
{
  launchd.user.agents.llama-cpp = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.llama-cpp}/bin/llama-server"
        "--models-dir"
        "/Users/${user}/models"
        "--no-models-autoload"
        "--jinja"
        "--host"
        "127.0.0.1"
        "--port"
        "8080"
        "-ngl"
        "999"
        "-c"
        "32768"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";
      StandardOutPath = "/tmp/llama-cpp.log";
      StandardErrorPath = "/tmp/llama-cpp.log";
    };
  };

  system.activationScripts.llamaModelsDir.text = ''
    mkdir -p "/Users/${user}/models"
  '';
}
