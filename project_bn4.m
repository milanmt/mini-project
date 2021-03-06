clc;
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MODEL 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating Directed Acyclic Graph
N = 5;
dag = zeros(5,5);
who = 1;
where_t = 2;
where_t1 = 3;
what_t = 4;
what_t1 = 5;
dag(who, [where_t where_t1 what_t what_t1]) = 1;
dag(where_t, [where_t1 what_t]) = 1;
dag(where_t1, [what_t1]) = 1;
discrete_nodes = 1:N;
node_sizes = [ 8 13 13 12 12 ];

% Making Bayes Net 
onodes = [2];
bnet = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes, 'observed', onodes,...
    'names', {'who', 'where_t', 'where_t1', 'what_t', 'what_t1'} );

% Forming Initial Probabilities
% AT A BUSY TIME DURING WORKING HOURS
% P(who) = Lecturers | PhD | Masters | Undergraduates | Technicians | Staff
% | Visitors | Janitor
p_who = [ 0.1 0.15 0.25 0.3 0.06 0.04 0.05 0.05 ];
% P(where) = Entries | Teaching Lab - 2| Hallway 1 - 3 | Lift - 6 | Hallway 2 - Hallway | Robot
% Lab | Vending Machines | Common Area - 10 | LG21 - 11| LG04 - 17| Hallway 3 - 14 | PhD
% Office - 4 | Nowhere on LGF
p_where = [0.045 0.1 0.065 0.04 0.065 0.1 0.045 0.25 0.015 0.15 0.065 0.05 0.01];
% P(what) Studying/Working on Laptops Individually | Eating | Group Discussions | Robot Work | Attending Lab| Chatting | Cleaning
% |Robot Evaluation | Demonstrating Lab | Walking/Waiting for someone | Other Activity | Getting Snack/Drink
p_what = [0.2 0.03 0.1 0.1 0.2 0.1 0.03 0.01 0.1 0.1 0.01 0.02];

% P(where|who) - who|where
p_where_who = [0.05 0.1 0.05 0.05 .05 .1 0.01 0.001 0.01 0.1 .05 0.01 0.419;
               0.025 0.1 0.025 0.025 0.025 0.4 0.01 0.01 0.0001 0.1 0.025 0.1 0.1549;
               0.025 0.1 0.025 0.025  0.025 0.1 0.01 0.4 0 0.2 0.025 0.00001 0.06499;
               0.025 0.2 0.025 0.025  0.025 0.1 0.01 0.3 0 0.2 0.025 0.00001 0.06499;
               0.025 0 0.025 0.025 0.025 0.00001 0.01 0.01 0.75499 0 0.025 0 0.1;
               0.1 0.001 0.1 0.1 0.1 .001 0.01 0.1 0 0.001 0.1 0.001 0.386;
               0.1 0 0.1 0.1 0.1 0 0.01 0.1 0 0 0.1 0 0.39;
               0.1 0.001 0.1 0.1 0.1 0 0.01 0.1 0 0.001 0.1 0 0.388];
p_where_who_b = reshape(p_where_who, [104,1]);
               
% P(what|where) -where|what
p_what_where = [ 0 0 0 0.22999 0 0.01 0.001 0.05 0 0.709 0.00001 0;
                 0.05 0.001 0.05 0.35 0.35 0.001 0.0001 0.0001 0.19769 0.0001 0.00001 0;
                 0 0 0 0.22999 0 0.01 0.001 0.05 0 0.709 0.00001 0;
                 0 0 0 0.2 0 0 0.001 0.001 0 0.798 0 0;
                 0 0 0 0.22999 0 0.01 0.001 0.05 0 0.709 0.00001 0;
                 0.1 0.001 0.0509 0.8469 0 0.001 0 0 0 0.0001 0.0001 0;
                 0 0 0 0 0 0 0 0 0 0 0 1;
                 0.44444 0.1 0.24444  0.1 0 0.1 0.001 0.01 0 0.0001 0.00001 0.00001;
                 0 0 0 0 0 0 0 0 0 0 1 0;
                 0.19 0.001 0.05 0.01 0.4509 0.001 0.0001 0.0001 0.29679 0.0001 0.00001 0;
                 0 0 0 0.22999 0 0.01 0.001 0.05 0 0.709 0.00001 0;
                 0.87899 0.001 0.1 0.01 0 0.01 0 0 0 0 0.00001 0;
                 0.083 0.083 0.083 0.083 0.083 0.083 0.083 0.083 0.083 0.083 0.087 0.083];                 

% P(what|who) -who|what
p_what_who = [ 0.00001 0.01 0.00001 0.00001 0 0.1 0 0.1 0.4 0.2 .001 0.18896;
               0.1 0.01 0.01 0.45899 0 0.001 0 0.01 0.3 0.1 0.00001 0.01;
               0.21999 0.01 0.2 0.2 0.25 0.01 0 0 0 0.1 0.00001 0.01;
               0.21999 0.01 0.2 0.2 0.25 0.01 0 0 0 0.1 0.00001 0.01;
               0 0.01 0 0 0 0.01 0 0 0 0.1 0.86999 0.01;
               0 0.0001 0 0 0 0.1 0 0 0 0.1 0.7899 0.01;
               0 0.01 0 0 0 0.44 0 0 0 0.44 0.1 0.01;
               0 0.02 0 0 0 0.01 0.84 0 0 0.1 0.01 0.02];
               
% P(wheret1|wheret) = wheret | wheret+1
p_wheret1_wheret = [0 0.5225 0.375 0 0 0.0625 0 0 0 0 0 0 0.04;
                    0.625 0 0.375 0 0 0 0 0 0 0 0 0 0;
                    0.2012 0.0592 0  0.0355 0.2189 0.3195 0.0473 0 0 0 0 0.1184 0;
                    0 0 1 0 0 0 0 0 0 0 0 0 0;
                    0 0 0.0518 0 0 0 0.0817 0.7193 0.1091 0 0.0381 0 0; 
                    0.1764 0 0.6176 0 0 0 0 0 0 0 0.206 0 0;
                    0 0 0.2051 0 0.6667 0 0 0 0 0 0.1282 0 0;
                    0 0 0 0 1 0 0 0 0 0 0 0 0;
                    0 0 0 0 1 0 0 0 0 0 0 0 0;
                    0 0 0 0 0 0 0 0 0 0 1 0 0;
                    0.1714 0 0 0 0.2571 0.1428 0.0858 0 0 0.3429 0 0 0;
                    0.33 0 0.67 0 0 0 0 0 0 0 0 0 0;
                    0.9412 0 0 0.0588 0 0 0 0 0 0 0 0 0];                    
p_wheret1_wheret_b = reshape(p_wheret1_wheret, [169,1]);                              

           

%P(wheret+1| who,wheret)
p_wheret1_whowhere = [];
for i = 1:node_sizes(2)
    p_wheret1_whowhere = [p_wheret1_whowhere ; p_where_who.*p_wheret1_wheret(i,:)];
end
nc = sum(p_wheret1_whowhere,2);
p_wheret1_whowhere = p_wheret1_whowhere./nc;
p_wheret1_whowhere = reshape(p_wheret1_whowhere, [1352,1]);


% P(what_t|who,where_t) - who, where_t | what_t 
p_what_whowhere =[];
for i = 1:node_sizes(2)
    p_what_whowhere = [p_what_whowhere ; p_what_who.*p_what_where(i,:)];
end
p_what_whowhere = p_what_whowhere./sum(p_what_whowhere,2);
p_what_whowhere = reshape(p_what_whowhere, [1248,1]);


% Setting Conditional Probabilities 
bnet.CPD{who} = tabular_CPD(bnet, who, p_who);
bnet.CPD{where_t} = tabular_CPD(bnet, where_t, p_where_who_b);
bnet.CPD{where_t1} = tabular_CPD(bnet, where_t1, p_wheret1_whowhere);
bnet.CPD{what_t} = tabular_CPD(bnet, what_t, p_what_whowhere);
bnet.CPD{what_t1} = tabular_CPD(bnet, what_t1, p_what_whowhere);

% Inference
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{2} = 1;
evidence{3} = 2;
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, who);
who_p = marg.T;
lecturers = who_p(1)
phd = who_p(2)
masters = who_p(3)
undergrad = who_p(4)
technicians = who_p(5)
staff = who_p(6)
visitors = who_p(7)
janitors = who_p(8)
marg = marginal_nodes(engine, where_t1);
where_p = marg.T;
% entries = where_p(1)
% Teachinglab = where_p(2)
% Hallway1 = where_p(3)
% Lift = where_p(4)
% Hallway2 = where_p(5)
% RobotLab = where_p(6)
% VendingMachines = where_p(7)
% CommonArea = where_p(8)
% LG21 = where_p(9)
% LG04 = where_p(10)
% Hallway3 = where_p(11)
% PhdOff = where_p(12)
% Nowhere = where_p(13)
marg = marginal_nodes(engine, what_t);
what_p = marg.T;
studying = what_p(1)
eating = what_p(2)
grp_discussions = what_p(3)
robot_work = what_p(4)
attending_lab = what_p(5)
chatting = what_p(6)
cleaning = what_p(7)
rob_eval = what_p(8)
demo = what_p(9)
walking_waiting = what_p(10)
other = what_p(11)
getting_food = what_p(12)
marg = marginal_nodes(engine, what_t1);
what1_p = marg.T;
studying = what1_p(1)
eating = what1_p(2)
grp_discussions = what1_p(3)
robot_work = what1_p(4)
attending_lab = what1_p(5)
chatting = what1_p(6)
cleaning = what1_p(7)
rob_eval = what1_p(8)
demo = what1_p(9)
walking_waiting = what1_p(10)
other = what1_p(11)
getting_food = what1_p(12)
