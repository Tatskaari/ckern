for hdr in glob("*.h"):
    c_library(
        name = hdr.removesuffix(".h"),
        hdrs = [hdr],
        visibility = ["PUBLIC"],
    )
