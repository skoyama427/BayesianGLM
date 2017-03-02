data {
  int<lower=0> N;
  int<lower=0> K;
  int Y[N];
  matrix<lower=0>[N,K] X;
}

parameters{
  vector<lower=1>[K] beta;
  real<lower=0.001> r;
}

model {
    vector[N] mu;
    vector[N] rv;
    
    r ~ cauchy(0, 1);
    beta ~ pareto(1, 1.5);
    
    for (n in 1:N){
        rv[n] = square(r+1) -1;
    }
    
    mu = X * (beta - 1) + 0.001;
    Y ~ neg_binomial(mu ./ rv, 1 / rv[1]);
}
