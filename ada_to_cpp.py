#!/usr/bin/env python3
import subprocess
import sys
from pathlib import Path
import textwrap

MODEL = "codellama" 

def run_ollama(prompt: str) -> str:
    """
    Send a prompt to Ollama and return the generated text.
    """
    process = subprocess.Popen(
        ["ollama", "run", MODEL],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    out, err = process.communicate(prompt)

    if process.returncode != 0:
        raise RuntimeError(f"Ollama error:\n{err}")

    return out

def build_prompt(ada_code: str) -> str:
    """
    Create a clear structured prompt for Code Llama.
    """
    prompt = f"""
    You are a code translation assistant.

    TASK:
    - Translate the following Ada code into C++17.
    - Preserve the behavior.
    - Output ONLY valid compilable C++ code.
    - Do NOT include markdown, comments, or explanations.

    ADA CODE:
    ```ada
    {ada_code}
    ```
    """
    return textwrap.dedent(prompt).strip()

def main():
    if len(sys.argv) < 3:
        print("Usage: python3 ada_to_cpp.py <input_ada_file> <output_cpp_file>")
        sys.exit(1)

    input_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])

    if not input_path.is_file():
        print(f"Input file not found: {input_path}")
        sys.exit(1)

    ada_code = input_path.read_text()

    prompt = build_prompt(ada_code)
    print("➡️ Sending Ada code to Code Llama...")

    cpp_code = run_ollama(prompt).strip()
    output_path.write_text(cpp_code)

    print(f"✅ C++ written to: {output_path}")

if __name__ == "__main__":
    main()
