{
  description = "A collection of flake templates";

  outputs =
    { self }:
    {
      templates = {
        latexmk = {
          path = ./latexmk;
        };

        ruby = {
          path = ./ruby;
        };
      };
    };
}
