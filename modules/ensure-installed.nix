{
  lib,
  pkgs,
  config,
  ...
}:

let ensure = config.wortel.ensureInstalled; in {
  wortel.ensureInstalled = lib.mkIf ensure.defaultAll {
    librariesWGPU = lib.mkDefault true;
    pythonMachineLearning = lib.mkDefault true;
  };

  # I'm unaware of any 'evaluate' function existing,
  # so instead just write the paths to a file
  environment.etc."wortel ensure installed.txt".text =
    ''
      # This file is just a hack needed because I cannot find an 'evaluate' function

    ''

    # Do I want to make seperate thing for additional bevy things?
    # I don't think bevy uses libGL btw
    + lib.optionalString ensure.librariesWGPU
    ''
      # Libraries for web GPU
      ${pkgs.libxkbcommon}
      ${pkgs.wayland}
      ${pkgs.libGL}

    ''

    # 'ipython' is not strictly for machine learning, but the nvim plugin uses it
    # Also 'tqdm' is used by one of those notebooks
    + lib.optionalString ensure.pythonMachineLearning
    ''
      # Python libraries for machine learning
      ${pkgs.python312Packages.ipython}
      ${pkgs.python312Packages.matplotlib}
      ${pkgs.python312Packages.scikit-learn}
      ${pkgs.python312Packages.pandas}
      ${pkgs.python312Packages.tqdm}
      ${pkgs.python312Packages.torchvision}

    '';
}
