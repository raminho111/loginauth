# ramoss4m dylib

Sistema de login via KeyAuth para IPA iOS.

**Como compilar:**

- Ter Xcode CLI tools instalado.
- Rodar `make` no diretório raiz.
- A dylib gerada é `libramoss4m.dylib`.

**Injeção:**

- Injetar a `libramoss4m.dylib` na IPA via seu método usual.
- Ao abrir o app, vai abrir alerta pedindo key.
- Só libera o app se key for validada via KeyAuth.
