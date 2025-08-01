use     Object::Pad v0.820;

class   TimeRange 1.00;

use     Management::Boilerplate::Code;

method list_of_acceptable_years  :common { return (2013..2025) };
method list_of_acceptable_months :common { return (1..12) };
#field   $list_of_acceptable_days   =   would differ by month, and whether a leap year or not. So rather than get complicated, skip it. Our aim is only ever to show the days available in any given year and month range.


__END__