/* =================================================================================
	MODULE : Data Manager
	It provides an interface to manipulate the program data base.
	It allows to add and remove elements and associate them with different values.

=================================================================================== */	

:- module(data_manager,[
		criterion/2,
		alternative/1,
		cpref_rule/2,
		stronger_rule/2,
		evidence/3,
		
		add_alternative/2,	
		remove_alternative/1,
		remove_alternatives/0,
		
		add_criterion/2,
		remove_criterion/1,
		remove_criteria/0,
		
		add_cpref_rule/2,
		remove_cpref_rule/1,
		remove_cpref_rules/0,
		
		add_rule_comparison/1,
		remove_rule_comparisons/0,
		
		generate_random_evidence/1
	]).

	:- dynamic alternative/1.
	:- dynamic criterion/2.
	:- dynamic stronger_rule/2.
	:- dynamic cpref_rule/2.
	:- dynamic evidence/3.
	
	
	:-use_module(cpref_rules_interpreter, [coherent_cpref_rule/1, op(1101, xfx, ==>)]).
	
	
	/***********************************************************************************
		add_alternative(+D, +Evidence).
		
		Adds a new alternative named D associated with the values expressed in Evidence.
		Evidence is a list of tuples of the form [C,V] where C must be a declared
		criterion and V is a legal value for C.
	************************************************************************************/
	add_alternative(D,Evidence):-
		not(alternative(D)),
		forall(member([C,V], Evidence),(
			criterion(C,Values),
			legal_value(V,Values),
			assert(evidence(D, C, V))
		)),
		assert(alternative(D)).
		
	
	/***********************************************************************************
		remove_alternative(+D).
		
		Removes the alternatives identified with D and all its related values.
	************************************************************************************/
	remove_alternative(D):-
		retract(alternative(D)),
		
		%Remove related evidence.
		forall(criterion(C),(
			retract(evidence(D,C,_))
		)).
		
	
	/***********************************************************************************
		remove_alternative(+D).
		
		Removes all the alternatives with all their values.
	************************************************************************************/
	remove_alternatives:-
		retractall(alternative(_)),
		
		%Remove related evidence.
		retractall(evidence(_,_,_)).	
	
	
	
	%===================================================================================
	%===================================================================================
	
	
	
	/***********************************************************************************
		add_criterion(+Criterion,+Values).
		
		Adds a new criterion Criterion assigning Values for its legal range of values.
		Values can be:
	 		-An ordered set (ordered from worse-to-better);
	 		-'number', to indicate that any numeber is valid. Lower numbers will be
	 		considered worse than higher ones; or well
	 		-'-number', to indicate that any numeber is valid, but higher number will be
	 		considered worse than lower numbers
	 		-'between(Min,Max)' to indicate that any integer between Min and Max is
	 		valid. When Min <= Max, lower numbers will be considered worse than higher,
	 		otherwise, when Min > Max, higher number will be considered worse than lower
	 		numbers.
	 		
	************************************************************************************/
	
	add_criterion(Criterion, Values):-
		not(criterion(Criterion,_)),
		
		%Verifies Values integrity
		(is_set(Values); member(Values,[number,-number,between(_,_)])),!,
		
		assert(criterion(Criterion,Values)).
	
	
	/***********************************************************************************
		remove_creterion(+Criterion).
		
		Removes the criterion Criterion.
	************************************************************************************/
	remove_criterion(Criterion):-
		retract(criterion(Criterion,_Values)).
	
	
	/***********************************************************************************
		remove_criterias.
		
		Removes all criteria.
	************************************************************************************/
	remove_criteria:-
		retractall(criterion(_,_)).
	
	
	%===================================================================================
	%===================================================================================
	
	
	/***********************************************************************************
		legal_value(+V,+Values).
		
		True iff V is a legal value of the range Values.
	************************************************************************************/
	legal_value(V,Values):-
		Values = number; Values = -number,!,
		number(V).
		
	legal_value(V,between(A,B)):-
		A >= B, !, A >= V, V >= B.
	
	legal_value(V,between(A,B)):-
		!,A =< V, V =< B.
	
	legal_value(V,Values):-
		member(V,Values).
		
	
	
	%===================================================================================
	%===================================================================================
	
	
	/***********************************************************************************
		add_cpref_rule(+Id,+Rule).
		
		Adds a new cpref_rule Rule associated with Id.
		Rule must be coherent and sintactically correct.
		
		See coherent_cpref_rule/1 in Cpref-rules Interpreter Module. 
	************************************************************************************/
	add_cpref_rule(Id, Rule):-
		coherent_cpref_rule(Rule),
		assert(cpref_rule(Id, Rule)).
	
	/***********************************************************************************
		remove_cpref_rule(+Id).
		
		Removes the cpref_rule associated with Id.
	************************************************************************************/
	remove_cpref_rule(Id):-
		retract(cpref_rule(Id,_)).
	
	/***********************************************************************************
		remove_cpref_rules.
		
		Removes all cpref_rules.
	************************************************************************************/
	remove_cpref_rules:-
		retractall(cpref_rule(_,_)),
		retractall(stronger_rule(_,_)).
	
		
	%===================================================================================
	%===================================================================================
	
	
	/***********************************************************************************
		add_rule_comparison(+R1 > +R2)  .
		
		Asserts that the rule with id R1 is stronger than that one with id R2.
	************************************************************************************/
	add_rule_comparison(R1 > R2):-
		ground(R1), cpref_rule(R1,_),
		ground(R2), cpref_rule(R2,_),
		assert(stronger_rule(R1,R2)).
	
	/***********************************************************************************
		remove_rule_comparisons.
		
		Removes all rules comparisons.
	************************************************************************************/
	remove_rule_comparisons:-
		retractall(stronger_rule(_,_)).
	
		
	
	/***********************************************************************************
		generate_random_evidence(+Alterantives_Amount).
		
		Generates a random data base where Alternatives_Amount is the number of
		alternatives considered to create the data base.
		It assigns random values to all the alternatives according to criteria already
		defined.
	************************************************************************************/
	generate_random_evidence(Alternatives_Amount):-
		integer(Alternatives_Amount),!,
		remove_alternatives,
		forall(between(1,Alternatives_Amount,Index), (atom_concat('d',Index,Id), assert(alternative(Id)))),
		forall(criterion(C,_),generate_random_evidence(C)).
		
	
	generate_random_evidence(C):-
		criterion(C,Values),
		forall(alternative(D),(
			random_value(V,Values),
			assert(evidence(D,C,V))
		)).
		
	
	random_value(V,Domain):-
		(Domain = number; Domain = -number),!,
		random(V).
		
	random_value(V,between(Min,Max)):-
		Min =< Max,!,
		random_between(Min,Max,V).
		
	random_value(V,between(Min,Max)):-
		!,random_between(Max,Min,V).
		
	random_value(V,List):-
		random_member(V,List).
	
	
	%=============== JUST TO DEBUG ==============%
	
	
	%=============== Evidence Set 1 ==============%
	
	alternative(a1). 
    alternative(a2). 
    alternative(a3).
    alternative(a4).
	
	evidence(a1,cost,bad).    	evidence(a2,cost,reg).     	evidence(a3,cost,vgood).	evidence(a4,cost,bad).
    evidence(a1,location,good). evidence(a2,location,good).	evidence(a3,location,reg).	evidence(a4,location,vgood).
    evidence(a1,size,reg).   	evidence(a2,size,good).     evidence(a3,size,good).		evidence(a4,size,bad).
	
	%=============================================%
	
	
	% ========================================
    %       Criteria
    % ========================================
    criterion(cost,[vbad,bad,reg,good,vgood]).
    criterion(location,[vbad,bad,reg,good,vgood]).
    criterion(size,[vbad,bad,reg,good,vgood]).
    
    
    stronger_rule(r4,r1).
    stronger_rule(r5,r1).
    stronger_rule(r6,r2).
    stronger_rule(r7,r2).
    stronger_rule(r8,r1). 
    
    
    % ========================================
    %       CP - Rules
    % ========================================
    
    %--Tim's Rules
    
    % R1: 
    cpref_rule(r1, 
        better(X,Y,cost) ==> pref(X,Y)
    ).
    
    % R2: 
    cpref_rule(r2, (
        better(X,Y,location),
        equal(X,Y,cost) ==> pref(X,Y)
    )).
    
    % R3:
    cpref_rule(r3, (
        better(X,Y,size),
        equal(X,Y,location),
        equal(X,Y,cost) ==> pref(X,Y)
    )).
    
    %================================================================
    
    %--August's Exceptions
    
    % R4: 
    cpref_rule(r4, (
        better(X,Y,location), min(X,location,good),
        worse(X,Y,cost) ==> pref(X,Y)
    )).
    
    % R5: 
    cpref_rule(r5, (
        better(X,Y,location), min(X,location,reg),
        worse(X,Y,cost), min(X,cost,bad) ==> pref(X,Y)
    )).
    
    %================================================================
    
    %--Kate's Exceptions
    
    % R6: 
    cpref_rule(r6, (
        better(X,Y,size), min(X,size,reg),
        worse(X,Y,location), min(X,location,bad), max(Y,location,good),
        better(X,Y,cost) ==> pref(X,Y)
    )).
    
    % R7: 
    cpref_rule(r7, (
        equal(X,Y,cost),
        worse(X,Y,location), min(X,location,bad), max(Y,location,good),
        better(X,Y,size), min(X,size,reg) ==> pref(X,Y)
    )).
	
	
	%--Kate's extra rule.
	
	% R8: Impose the minimal requirements to prefer the size over the location.
    cpref_rule(r8, (
        better(X,Y,cost), min(X,cost,good),
        better(X,Y,size), min(X,size,reg) ==> pref(X,Y)
    )).
    
    