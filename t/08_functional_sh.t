# 08_functional_sh.t # as of 8/4/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} # 
use Test::Simple tests =>
700;
use lib ("./t");
use List::Compare::Functional qw(:originals :aliases);
use Test::ListCompareSpecial qw(:seen);

$loaded = 1;
ok($loaded);

######################### End of black magic.

my %seen = ();
my (@unique, @complement, @intersection, @union, @symmetric_difference, @bag);
my ($unique_ref, $complement_ref, $intersection_ref, $union_ref, $symmetric_difference_ref, $bag_ref);
my ($LR, $RL, $eqv, $disj, $return);
my (@nonintersection, @shared);
my ($nonintersection_ref, @shared_ref);
my ($memb_hash_ref, $memb_arr_ref, @memb_arr);

my @a0 = qw(abel abel baker camera delta edward fargo golfer);
my @a1 = qw(baker camera delta delta edward fargo golfer hilton);
my @a2 = qw(fargo golfer hilton icon icon jerky);
my @a3 = qw(fargo golfer hilton icon icon);
my @a4 = qw(fargo fargo golfer hilton icon);
my @a8 = qw(kappa lambda mu);

my (%h0, %h1, %h2, %h3, %h4, %h8);
$h0{$_}++ for @a0;
$h1{$_}++ for @a1;
$h2{$_}++ for @a2;
$h3{$_}++ for @a3;
$h4{$_}++ for @a4;
$h8{$_}++ for @a8;

@union = get_union( [ \%h0, \%h1 ] );
ok($union[0] eq 'abel');
ok($union[1] eq 'baker');
ok($union[2] eq 'camera');
ok($union[3] eq 'delta');
ok($union[4] eq 'edward');
ok($union[5] eq 'fargo');
ok($union[6] eq 'golfer');
ok($union[-1] eq 'hilton');

$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$union_ref = get_union_ref( [ \%h0, \%h1 ] );
ok(${$union_ref}[0] eq 'abel');
ok(${$union_ref}[1] eq 'baker');
ok(${$union_ref}[2] eq 'camera');
ok(${$union_ref}[3] eq 'delta');
ok(${$union_ref}[4] eq 'edward');
ok(${$union_ref}[5] eq 'fargo');
ok(${$union_ref}[6] eq 'golfer');
ok(${$union_ref}[-1] eq 'hilton');

$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@shared = get_shared( [ \%h0, \%h1 ] );
ok($shared[0] eq 'baker');
ok($shared[1] eq 'camera');
ok($shared[2] eq 'delta');
ok($shared[3] eq 'edward');
ok($shared[4] eq 'fargo');
ok($shared[-1] eq 'golfer');

$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$shared_ref = get_shared_ref( [ \%h0, \%h1 ] );
ok(${$shared_ref}[0] eq 'baker');
ok(${$shared_ref}[1] eq 'camera');
ok(${$shared_ref}[2] eq 'delta');
ok(${$shared_ref}[3] eq 'edward');
ok(${$shared_ref}[4] eq 'fargo');
ok(${$shared_ref}[-1] eq 'golfer');

$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@intersection = get_intersection( [ \%h0, \%h1 ] );
ok($intersection[0] eq 'baker');
ok($intersection[1] eq 'camera');
ok($intersection[2] eq 'delta');
ok($intersection[3] eq 'edward');
ok($intersection[4] eq 'fargo');
ok($intersection[-1] eq 'golfer');

$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$intersection_ref = get_intersection_ref( [ \%h0, \%h1 ] );
ok(${$intersection_ref}[0] eq 'baker');
ok(${$intersection_ref}[1] eq 'camera');
ok(${$intersection_ref}[2] eq 'delta');
ok(${$intersection_ref}[3] eq 'edward');
ok(${$intersection_ref}[4] eq 'fargo');
ok(${$intersection_ref}[-1] eq 'golfer');

$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@unique = get_unique( [ \%h0, \%h1 ] );
ok($unique[-1] eq 'abel');

$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$unique_ref = get_unique_ref( [ \%h0, \%h1 ] );
ok(${$unique_ref}[-1] eq 'abel');

$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@complement = get_complement( [ \%h0, \%h1 ] );
ok($complement[-1] eq 'hilton');

$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$complement_ref = get_complement_ref( [ \%h0, \%h1 ] );
ok(${$complement_ref}[-1] eq 'hilton');

$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@symmetric_difference = get_symmetric_difference( [ \%h0, \%h1 ] );
ok($symmetric_difference[0] eq 'abel');
ok($symmetric_difference[-1] eq 'hilton');

$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref( [ \%h0, \%h1 ] );
ok(${$symmetric_difference_ref}[0] eq 'abel');
ok(${$symmetric_difference_ref}[-1] eq 'hilton');

$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@symmetric_difference = get_symdiff( [ \%h0, \%h1 ] );
ok($symmetric_difference[0] eq 'abel');
ok($symmetric_difference[-1] eq 'hilton');

$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$symmetric_difference_ref = get_symdiff_ref( [ \%h0, \%h1 ] );
ok(${$symmetric_difference_ref}[0] eq 'abel');
ok(${$symmetric_difference_ref}[-1] eq 'hilton');

$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@nonintersection = get_nonintersection( [ \%h0, \%h1 ] );
ok($nonintersection[0] eq 'abel');
ok($nonintersection[-1] eq 'hilton');

$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$nonintersection_ref = get_nonintersection_ref( [ \%h0, \%h1 ] );
ok(${$nonintersection_ref}[0] eq 'abel');
ok(${$nonintersection_ref}[-1] eq 'hilton');

$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@bag = get_bag( [ \%h0, \%h1 ] );
ok($bag[0] eq 'abel');
ok($bag[1] eq 'abel');
ok($bag[2] eq 'baker');
ok($bag[3] eq 'baker');
ok($bag[4] eq 'camera');
ok($bag[5] eq 'camera');
ok($bag[6] eq 'delta');
ok($bag[7] eq 'delta');
ok($bag[8] eq 'delta');
ok($bag[9] eq 'edward');
ok($bag[10] eq 'edward');
ok($bag[11] eq 'fargo');
ok($bag[12] eq 'fargo');
ok($bag[13] eq 'golfer');
ok($bag[14] eq 'golfer');
ok($bag[-1] eq 'hilton');

$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);
ok($seen{'baker'} == 2);
ok($seen{'camera'} == 2);
ok($seen{'delta'} == 3);
ok($seen{'edward'} == 2);
ok($seen{'fargo'} == 2);
ok($seen{'golfer'} == 2);
ok($seen{'hilton'} == 1);
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$bag_ref = get_bag_ref( [ \%h0, \%h1 ] );
ok(${$bag_ref}[0] eq 'abel');
ok(${$bag_ref}[1] eq 'abel');
ok(${$bag_ref}[2] eq 'baker');
ok(${$bag_ref}[3] eq 'baker');
ok(${$bag_ref}[4] eq 'camera');
ok(${$bag_ref}[5] eq 'camera');
ok(${$bag_ref}[6] eq 'delta');
ok(${$bag_ref}[7] eq 'delta');
ok(${$bag_ref}[8] eq 'delta');
ok(${$bag_ref}[9] eq 'edward');
ok(${$bag_ref}[10] eq 'edward');
ok(${$bag_ref}[11] eq 'fargo');
ok(${$bag_ref}[12] eq 'fargo');
ok(${$bag_ref}[13] eq 'golfer');
ok(${$bag_ref}[14] eq 'golfer');
ok(${$bag_ref}[-1] eq 'hilton');

$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);
ok($seen{'baker'} == 2);
ok($seen{'camera'} == 2);
ok($seen{'delta'} == 3);
ok($seen{'edward'} == 2);
ok($seen{'fargo'} == 2);
ok($seen{'golfer'} == 2);
ok($seen{'hilton'} == 1);
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$LR = is_LsubsetR( [ \%h0, \%h1 ] );
ok(! $LR);

$RL = is_RsubsetL( [ \%h0, \%h1 ] );
ok(! $RL);

$eqv = is_LequivalentR( [ \%h0, \%h1 ] );
ok(! $eqv);

$eqv = is_LeqvlntR( [ \%h0, \%h1 ] );
ok(! $eqv);

$disj = is_LdisjointR( [ \%h0, \%h1 ] );
ok(! $disj);

$return = print_subset_chart( [ \%h0, \%h1 ] );
ok($return);

$return = print_equivalence_chart( [ \%h0, \%h1 ] );
ok($return);

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'abel' ] );
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'baker' ] );
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'camera' ] );
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'delta' ] );
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'edward' ] );
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'fargo' ] );
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'golfer' ] );
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'hilton' ] );
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'icon' ] );
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'jerky' ] );
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'zebra' ] );
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'abel' ] );
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'baker' ] );
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'camera' ] );
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'delta' ] );
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'edward' ] );
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'fargo' ] );
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'golfer' ] );
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'hilton' ] );
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'icon' ] );
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'jerky' ] );
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'zebra' ] );
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));


$memb_hash_ref = are_members_which( [ \%h0, \%h1 ] , 
    [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ]);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));

ok(is_member_any( [ \%h0, \%h1 ], [ 'abel' ] ));
ok(is_member_any( [ \%h0, \%h1 ], [ 'baker' ] ));
ok(is_member_any( [ \%h0, \%h1 ], [ 'camera' ] ));
ok(is_member_any( [ \%h0, \%h1 ], [ 'delta' ] ));
ok(is_member_any( [ \%h0, \%h1 ], [ 'edward' ] ));
ok(is_member_any( [ \%h0, \%h1 ], [ 'fargo' ] ));
ok(is_member_any( [ \%h0, \%h1 ], [ 'golfer' ] ));
ok(is_member_any( [ \%h0, \%h1 ], [ 'hilton' ] ));
ok(! is_member_any( [ \%h0, \%h1 ], [ 'icon' ] ));
ok(! is_member_any( [ \%h0, \%h1 ], [ 'jerky' ] ));
ok(! is_member_any( [ \%h0, \%h1 ], [ 'zebra' ] ));

$memb_hash_ref = are_members_any( [ \%h0, \%h1 ],
    [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ]);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));

$vers = get_version;
ok($vers);

$LR = is_LsubsetR([ \%h2, \%h3 ]);
ok(! $LR);

$RL = is_RsubsetL([ \%h2, \%h3 ]);
ok($RL);

$eqv = is_LequivalentR([ \%h2, \%h3 ]);
ok(! $eqv);

$eqv = is_LeqvlntR([ \%h2, \%h3 ]);
ok(! $eqv);

$eqv = is_LequivalentR([ \%h3, \%h4 ]);
ok($eqv);

$eqv = is_LeqvlntR([ \%h3, \%h4 ]);
ok($eqv);

$disj = is_LdisjointR( [ \%h3, \%h4 ] );
ok(! $disj);

$disj = is_LdisjointR( [ \%h4, \%h8 ] );
ok($disj);

########## BELOW:  Tests for '-u' option ##########

@union = get_union('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$union_ref = get_union_ref('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@shared = get_shared('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$shared_ref = get_shared_ref('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@intersection = get_intersection('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$intersection_ref = get_intersection_ref('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@unique = get_unique('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$unique_ref = get_unique_ref('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@complement = get_complement('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$complement_ref = get_complement_ref('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@symmetric_difference = get_symmetric_difference('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@symmetric_difference = get_symdiff('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@nonintersection = get_nonintersection('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$nonintersection_ref = get_nonintersection_ref('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@bag = get_bag('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);
ok($seen{'baker'} == 2);
ok($seen{'camera'} == 2);
ok($seen{'delta'} == 3);
ok($seen{'edward'} == 2);
ok($seen{'fargo'} == 2);
ok($seen{'golfer'} == 2);
ok($seen{'hilton'} == 1);
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$bag_ref = get_bag_ref('-u', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);
ok($seen{'baker'} == 2);
ok($seen{'camera'} == 2);
ok($seen{'delta'} == 3);
ok($seen{'edward'} == 2);
ok($seen{'fargo'} == 2);
ok($seen{'golfer'} == 2);
ok($seen{'hilton'} == 1);
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

########## BELOW:  Tests for '--unsorted' option ##########

@union = get_union('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$union_ref = get_union_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@shared = get_shared('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$shared_ref = get_shared_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@intersection = get_intersection('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$intersection_ref = get_intersection_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});
ok(exists $seen{'baker'});
ok(exists $seen{'camera'});
ok(exists $seen{'delta'});
ok(exists $seen{'edward'});
ok(exists $seen{'fargo'});
ok(exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@unique = get_unique('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$unique_ref = get_unique_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(! exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@complement = get_complement('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$complement_ref = get_complement_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@symmetric_difference = get_symmetric_difference('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@symmetric_difference = get_symdiff('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@nonintersection = get_nonintersection('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$nonintersection_ref = get_nonintersection_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});
ok(! exists $seen{'baker'});
ok(! exists $seen{'camera'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'edward'});
ok(! exists $seen{'fargo'});
ok(! exists $seen{'golfer'});
ok(exists $seen{'hilton'});
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

@bag = get_bag('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);
ok($seen{'baker'} == 2);
ok($seen{'camera'} == 2);
ok($seen{'delta'} == 3);
ok($seen{'edward'} == 2);
ok($seen{'fargo'} == 2);
ok($seen{'golfer'} == 2);
ok($seen{'hilton'} == 1);
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();

$bag_ref = get_bag_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);
ok($seen{'baker'} == 2);
ok($seen{'camera'} == 2);
ok($seen{'delta'} == 3);
ok($seen{'edward'} == 2);
ok($seen{'fargo'} == 2);
ok($seen{'golfer'} == 2);
ok($seen{'hilton'} == 1);
ok(! exists $seen{'icon'});
ok(! exists $seen{'jerky'});
%seen = ();



