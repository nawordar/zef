use v6;
use Zef::Authority;
plan 2;
use Test;

subtest {
    my $authority = Zef::Authority.new;
    my @response  = $authority.search('zef');
    ok @response.elems, "Got modules (search: zef)";

    $authority = Zef::Authority.new;
    @response = $authority.search("#");
    is @response.elems, 0, "Got 0 modules (search: #)";
# nok %response
}, 'SSL not required';

subtest {
    ENTER {
        try require IO::Socket::SSL;
        if ::('IO::Socket::SSL') ~~ Failure {
            print("ok 2 - # Skip: IO::Socket::SSL not available\n");
            return;
        }
    }

    my $authority = Zef::Authority.new;
    my %response  = $authority.register(username => 'zef', password => 'pass');
    is %response.<failure>, 1, "Username already registered";

    $authority = Zef::Authority.new;
    nok $authority.login(username => 'zef', password => 'pass'), "Login failed";

    $authority = Zef::Authority.new;
    ok $authority.login(username => 'zef', password => 'zef'), "Login worked";
}, 'SSL required';

done();