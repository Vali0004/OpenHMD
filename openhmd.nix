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

let
  examplesOnOff = if withExamples then "ON" else "OFF";
in stdenv.mkDerivation {
  name = "OpenHMD";
  allowSubstitutes = false;
  src = ./.;
  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    hidapi
    libusb1
    opencv
  ] ++ lib.optionals withExamples [
    sdl3
    glew
    libGL
  ];


  cmakeFlags = [
    "-DBUILD_BOTH_STATIC_SHARED_LIBS=ON"
    "-DOPENHMD_EXAMPLE_SIMPLE=${examplesOnOff}"
    "-DOPENHMD_EXAMPLE_SDL=${examplesOnOff}"
    "-DOpenGL_GL_PREFERENCE=GLVND"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  postInstall = lib.optionalString withExamples ''
    mkdir -p $out/bin
    install -D examples/simple/simple $out/bin/openhmd-example-simple
    install -D examples/opengl/openglexample $out/bin/openhmd-example-opengl
  '';
}
