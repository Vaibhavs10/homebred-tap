class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # pull from git tag to get submodules
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b2963",
      revision: "95fb0aefab568348da159efdd370e064d1b35f97"
  license "MIT"

  livecheck do
    throttle 10
  end

  depends_on arch: :arm64
  depends_on :macos
  depends_on "curl"

  def install
    system "make", "LLAMA_FATAL_WARNINGS=ON", "LLAMA_METAL_EMBED_LIBRARY=ON", "LLAMA_CURL=ON"

    bin.install "./main" => "llama-cli"
    bin.install "./server" => "llama-server"
  end

  test do
    llama_cli_command = ["llama-cli",
                         "--hf-repo",
                         "ggml-org/tiny-llamas",
                         "-m",
                         "stories15M-q4_0.gguf",
                         "-n",
                         "400"].join(" ")
    assert_includes shell_output(llama_cli_command), "<s>"
  end
end
