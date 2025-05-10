{
  coreutils,
  dpkg,
  fetchurl,
  file,
  ghostscript,
  gnugrep,
  gnused,
  makeWrapper,
  perl,
  lib,
  stdenv,
  which,
}: let
  # model = "mfcl3770cdw";
  model = "mfc6890cdw";
  version = "1.1.2-4";
  src = fetchurl {
    # https://download.brother.com/welcome/dlf006204/mfc6890cdwlpr-1.1.2-4.i386.deb
    url = "https://download.brother.com/welcome/dlf006204/${model}lpr-${version}.i386.deb";
    sha256 = "sha256-PfdMOh+Xgfr9WSIEfJW8DCpA8o8GYlKnFllLDEfpZ4M=";
  };
  reldir = "usr/local/Brother/Printer/${model}";
in rec {
  driver = stdenv.mkDerivation rec {
    inherit src version;
    name = "${model}drv-${version}";

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];

    unpackPhase = ''
      dpkg-deb -x $src $out
    '';

    installPhase = ''
      dir="$out/${reldir}"
      filter=$dir/lpd/filter${model}

      substituteInPlace $filter \
        --replace-fail "BR_PRT_PATH=" "BR_PRT_PATH= \"$dir\"; #"
        # --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
        # --replace /usr/bin/perl ${perl}/bin/perl \

      wrapProgram $filter \
        --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          # file
          ghostscript
          gnugrep
          gnused
          which
        ]
      }

      # need to use i686 glibc here, these are 32bit proprietary binaries
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $dir/lpd/br${model}filter
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} driver";
      homepage = "http://www.brother.com/";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      license = lib.licenses.unfree;
      platforms = [
        "x86_64-linux"
        "i686-linux"
      ];
      # maintainers = [ lib.maintainers.steveej ];
    };
  };

  cupswrapper = stdenv.mkDerivation rec {
    inherit version src;
    name = "${model}cupswrapper-${version}";

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];

    unpackPhase = ''
      dpkg-deb -x $src $out
    '';

    installPhase = ''
      basedir=${driver}/${reldir}
      dir=$out/${reldir}
      substituteInPlace $dir/cupswrapper/brother_lpdwrapper_${model} \
        --replace /usr/bin/perl ${perl}/bin/perl \
        --replace "basedir =~" "basedir = \"$basedir\"; #" \
        --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
      wrapProgram $dir/cupswrapper/brother_lpdwrapper_${model} \
        --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
        ]
      }
      mkdir -p $out/lib/cups/filter
      mkdir -p $out/share/cups/model
      ln $dir/cupswrapper/brother_lpdwrapper_${model} $out/lib/cups/filter
      ln $dir/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} CUPS wrapper driver";
      homepage = "http://www.brother.com/";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      license = lib.licenses.gpl2Plus;
      platforms = [
        "x86_64-linux"
        "i686-linux"
      ];
      # maintainers = [ lib.maintainers.steveej ];
    };
  };
}
