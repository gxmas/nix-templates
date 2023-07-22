{
    description = "gxmas flake templates";

    outputs = { self, ... }: {
        templates = {
            haskell-basic = {
                path = ./template-haskell-basic;
                description = "A basic haskell project";
            };
        };
    };
}
