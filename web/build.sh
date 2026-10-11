#!/usr/bin/env bash
# Ensambla la calculadora y arma la pagina en web/publicar/ (DOSBox en el navegador con js-dos).
# Requiere: JWasm (variable JWASM_BIN o "jwasm" en el PATH; JWASM no, JWasm la lee como opciones), curl, zip.
set -euo pipefail

cd "$(dirname "$0")/.."
JWASM_BIN="${JWASM_BIN:-jwasm}"
JSDOS_VERSION=8.4.1
SALIDA=web/publicar
TEMP=$(mktemp -d)
trap 'rm -rf "$TEMP"' EXIT

rm -rf "$SALIDA"
mkdir -p "$SALIDA/js-dos/emulators"

# 1. ensamblar: -mz genera directamente el .EXE de DOS, sin linker
"$JWASM_BIN" -mz -Fo="$TEMP/CALC.EXE" pro2.asm

# 2. paquete .jsdos: el programa y la configuracion de DOSBox
mkdir -p "$TEMP/bundle/.jsdos"
cp "$TEMP/CALC.EXE" "$TEMP/bundle/"
cp web/dosbox.conf "$TEMP/bundle/.jsdos/dosbox.conf"
(cd "$TEMP/bundle" && zip -qr ../calculadora.jsdos .)
cp "$TEMP/calculadora.jsdos" "$SALIDA/"

# 3. js-dos (se sirve desde el mismo dominio: el emulador corre en un Web Worker)
curl -fsSL "https://registry.npmjs.org/js-dos/-/js-dos-$JSDOS_VERSION.tgz" | tar -xz -C "$TEMP"
cp "$TEMP/package/dist/js-dos.js" "$TEMP/package/dist/js-dos.css" "$SALIDA/js-dos/"
for f in emulators.js wdosbox.js wdosbox.wasm wlibzip.js wlibzip.wasm; do
    cp "$TEMP/package/dist/emulators/$f" "$SALIDA/js-dos/emulators/"
done

cp web/index.html "$SALIDA/"
echo "Listo: $SALIDA"
