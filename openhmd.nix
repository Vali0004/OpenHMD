{ stdenv
, cmake
, lib
, ninja
, pkg-config
, hidapi
, libusb1
, opencv
, libGL
, glew
, sdl3
, withExamples ? true
}:

stdenv.mkDerivation {
  name = "OpenHMD";
  allowSubstitutes = false;
  src = ./.;
  nativeBuildInputs = [ cmake pkg-config ninja ];

  buildInputs = [
    hidapi
    libusb1
    opencv
  ] ++ lib.optionals withExamples [
    sdl3
    glew
    libGL
  ];

  installPhase = ''
    mkdir -p $out/lib
    cp libopenhmd.a $out/lib
    ${lib.optionalString withExamples ''
      mkdir -p $out/bin
      cp examples/simple/simple $out/bin
      cp examples/opengl/openglexample $out/bin
    ''}
  '';
}
