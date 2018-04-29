java_binary(
    name = "hsp_transpiler",
    main_class = "me.ruin.hsp.generated.Parser",
    deps = [":main"],
)

kotlin_library(
    name = "main",
    deps = ["//src/java/me/ruin/hsp/generated:generated_lib",
            ],
    srcs = glob(["src/kotlin/*.kt"]),
)