#include <windows.h>

// Wir definieren den Export sauber für den MSVC-Compiler
#define MA_API __declspec(dllexport)

#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"

// Diese Brücken-Funktionen verpacken das C-sizeof in echte DLL-Exports für Delphi
MA_API size_t ma_engine_sizeof() {
    return sizeof(ma_engine);
}

MA_API size_t ma_sound_sizeof() {
    return sizeof(ma_sound);
}
