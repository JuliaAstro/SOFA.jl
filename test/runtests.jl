using ParallelTestRunner: runtests, find_tests, parse_args
using SOFA

const init_code = quote
    using SOFA
    using Test
end

args = parse_args(Base.ARGS)
testsuite = find_tests(@__DIR__)

runtests(SOFA, args; testsuite, init_code)
