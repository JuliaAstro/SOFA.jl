export iauEpb
"""
Julian Date to Besselian Epoch.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

### Given
   dj1,dj2    double     Julian Date (Notes 3,4)

Returned (function value):
              double     Besselian Epoch.


Notes:
1) Besselian Epoch is a method of expressing a moment in time as a
   year plus fraction.  It was superseded by Julian Year (see the
   function iauEpj).
2) The start of a Besselian year is when the right ascension of
   the fictitious mean Sun is 18h 40m, and the unit is the tropical
   year.  The conventional definition (see Lieske 1979) is that
   Besselian Epoch B1900.0 is JD 2415020.31352 and the length of the
   year is 365.242198781 days.
3) The time scale for the JD, originally Ephemeris Time, is TDB,
   which for all practical purposes in the present context is
   indistinguishable from TT.
4) The Julian Date is supplied in two pieces, in the usual SOFA
   manner, which is designed to preserve time resolution.  The
   Julian Date is available as a single number by adding dj1 and
   dj2.  The maximum resolution is achieved if dj1 is 2451545.0
   (J2000.0).

### References

   Lieske, J.H., 1979. Astron.Astrophys., 73, 282.

This revision:  2023 May 5

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauEpb(dj1::Real, dj2::Real)
    return ccall(
        (:iauEpb, libsofa_c), Cdouble,
        (Cdouble, Cdouble),
        convert(Float64, dj1), convert(Float64, dj2)
    )
end
