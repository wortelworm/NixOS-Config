{lib, ...}: {
  # I like knowing what propiatary software I use.
  nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        # Still want to take a look at this
        "obsidian"

        # The problem with vscodium is that the microsoft specific extensions don't seem to work..
        "vscode"
        "vscode-extension-ms-vscode-cpptools"
        "vscode-extension-ms-dotnettools-csharp"

        # Nvidia driver and gpu compute stuff
        "nvidia-x11"
        "cuda-merged"
        "cuda_cccl"
        "cuda_cudart"
        "cuda_cuobjdump"
        "cuda_cupti"
        "cuda_cuxxfilt"
        "cuda_gdb"
        "cuda_nvcc"
        "cuda_nvdisasm"
        "cuda_nvml_dev"
        "cuda_nvprune"
        "cuda_nvrtc"
        "cuda_nvtx"
        "cuda_profiler_api"
        "cuda_sanitizer_api"
        "libcublas"
        "libcufft"
        "libcurand"
        "libcusolver"
        "libcusparse"
        "libnpp"
        "libnvjitlink"

        # Steam I can understand, its fine
        "steam"
        "steam-unwrapped"

        # Driver for the MFC-6890CDW brother printer
        "mfc6890cdw-lpr"
      ];
}
