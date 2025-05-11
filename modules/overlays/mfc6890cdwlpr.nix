{
  a2ps,
  coreutils,
  dpkg,
  fetchurl,
  file,
  ghostscript,
  gnugrep,
  gnused,
  gawk,
  makeWrapper,
  pkgsi686Linux,
  psutils,
  lib,
  stdenv,
}: let
  model = "mfc6890cdw";
  version = "1.1.2-4";
in rec {
  driver = stdenv.mkDerivation rec {
    pname = "${model}-lpr";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf006204/${model}lpr-${version}.i386.deb";
      sha256 = "sha256-PfdMOh+Xgfr9WSIEfJW8DCpA8o8GYlKnFllLDEfpZ4M=";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];

    unpackPhase = ''
      dpkg-deb -x $src $out
    '';

    installPhase = ''
      dir=$out/usr/local/Brother/Printer/${model}

      patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $dir/lpd/br${model}filter

      wrapProgram $dir/inf/setupPrintcapij \
        --prefix PATH : ${
        lib.makeBinPath [
          coreutils
        ]
      }

      substituteInPlace $dir/lpd/filter${model} \
        --replace "/usr/" "$out/usr/"

      wrapProgram $dir/lpd/filter${model} \
        --prefix PATH : ${
        lib.makeBinPath [
          a2ps
          coreutils
          file
          ghostscript
          gnused
        ]
      }

      substituteInPlace $dir/lpd/psconvertij2 \
        --replace '`which gs`' "${ghostscript}/bin/gs"

      wrapProgram $dir/lpd/psconvertij2 \
        --prefix PATH : ${
        lib.makeBinPath [
          gnused
          gawk
        ]
      }
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
    pname = "${model}-cupswrapper";
    inherit version;

    src = fetchurl {
      # https://download.brother.com/welcome/dlf006206/mfc6890cdwcupswrapper-1.1.2-4.i386.deb
      url = "https://download.brother.com/welcome/dlf006206/${model}cupswrapper-${version}.i386.deb";
      sha256 = "sha256-6EAz6aFHigTRYmeoH8cCvenP4OpFZsONduaqyL5+MgU=";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];

    # buildInputs = [ cups ghostscript ...]

    unpackPhase = ''
      dpkg-deb -x $src $out
    '';

    installPhase = ''
      lpr=${driver}/usr/local/Brother/Printer/${model}
      dir=$out/usr/local/Brother/Printer/${model}

      # need to use i686 glibc here, these are 32bit proprietary binaries
      patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $dir/cupswrapper/brcupsconfpt1

      #comment out lpadmin commands to prohibit changes to CUPS config by just installing this driver.
      substituteInPlace $dir/cupswrapper/cupswrapper${model} \
        --replace "lpadmin" "#lpadmin" \
        --replace "/usr/" "$out/usr/"

      #${model}lpr is a dependency of this package. Link all files of ${model}lpr into the $out/usr folder, as other scripts depend on these files being present.
      #Ideally, we would use substituteInPlace for each file this package actually requires. But the scripts of Brother use variables to dynamically build the paths
      #at runtime, making this approach more complex. Hence, the easier route of simply linking all files was choosen.
      find "$lpr" -type f -exec sh -c "mkdir -vp \$(echo '{}' | sed 's|$lpr|$dir|g' | xargs dirname) && ln -s '{}' \$(echo '{}' | sed 's|$lpr|$dir|g')" \;

      mkdir -p $out/usr/share/ppd/
      mkdir -p $out/usr/lib64/cups/filter
      # THIS LINE IS CHANGED!!
      sed -i '971,1002d' $dir/cupswrapper/cupswrapper${model}
      $dir/cupswrapper/cupswrapper${model}

      chmod +x $out/usr/lib64/cups/filter/brlpdwrapper${model}
      wrapProgram $out/usr/lib64/cups/filter/brlpdwrapper${model} --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          psutils
          gnugrep
          gnused
        ]
      }

      mkdir -p $out/lib/cups/filter
      mkdir -p $out/share/cups/model
      ln $out/usr/lib64/cups/filter/brlpdwrapper${model} $out/lib/cups/filter
      ln $dir/cupswrapper/cupswrapper${model} $out/lib/cups/filter
      ln $out/usr/share/ppd/br${model}.ppd $out/share/cups/model
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
