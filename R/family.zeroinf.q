# These functions are
# Copyright (C) 1998-2009 T.W. Yee, University of Auckland. All rights reserved.








dzanegbin = function(x, p0, size, prob=NULL, munb=NULL, log=FALSE) {
    if (length(munb)) {
        if (length(prob))
            stop("'prob' and 'munb' both specified")
        prob <- size/(size + munb)
    }
    if(!is.logical(log.arg <- log)) stop("bad input for 'log'")
    rm(log)

    L = max(length(x), length(p0), length(prob), length(size))
    x = rep(x, len=L); p0 = rep(p0, len=L);
    prob = rep(prob, len=L); size = rep(size, len=L);
    ans = rep(0.0, len=L)
    if(!is.Numeric(p0) || any(p0 < 0) || any(p0 > 1))
        stop("'p0' must be in [0,1]")
    if(!is.Numeric(prob, posit=TRUE))
        stop("'prob' must be in [0,Inf)")
    if(!is.Numeric(size, posit=TRUE))
        stop("'size' must be in [0,Inf)")
    index0 = x==0

    if(log.arg) {
        ans[ index0] = log(p0[index0])
        ans[!index0] = log1p(-p0[!index0]) +
                       dposnegbin(x[!index0], prob=prob[!index0],
                                  size=size[!index0], log=TRUE)
    } else {
        ans[ index0] = p0[index0]
        ans[!index0] = (1-p0[!index0]) * dposnegbin(x[!index0],
                         prob=prob[!index0], size=size[!index0])
    }
    ans
}



pzanegbin = function(q, p0, size, prob=NULL, munb=NULL) {
    if (length(munb)) {
        if (length(prob))
            stop("'prob' and 'munb' both specified")
        prob <- size/(size + munb)
    }
    L = max(length(q), length(p0), length(prob), length(size))
    q = rep(q, len=L); p0 = rep(p0, len=L);
    prob = rep(prob, len=L); size = rep(size, len=L);
    ans = rep(0.0, len=L)

    if(!is.Numeric(p0) || any(p0 < 0) || any(p0 > 1))
        stop("'p0' must be in [0,1]")
    ans[q >  0] = p0[q > 0] + (1-p0[q > 0]) *
                  pposnegbin(q[q > 0], size=size[q > 0], prob=prob[q > 0])
    ans[q <  0] = 0
    ans[q == 0] = p0[q == 0]
    ans
}

qzanegbin = function(p, p0, size, prob=NULL, munb=NULL) {
    if (length(munb)) {
        if (length(prob))
            stop("'prob' and 'munb' both specified")
        prob <- size/(size + munb)
    }
    L = max(length(p), length(p0), length(prob), length(size))
    p = rep(p, len=L); p0 = rep(p0, len=L);
    prob = rep(prob, len=L); size = rep(size, len=L);
    ans = rep(0.0, len=L)

    if(!is.Numeric(p0) || any(p0 < 0) || any(p0 > 1))
        stop("'p0' must be between 0 and 1 inclusive")
    ans = p
    ans[p <= p0] = 0
    ans[p > p0] = qposnegbin((p[p>p0]-p0[p>p0])/(1-p0[p>p0]), prob=prob[p>p0],
                             size=size[p>p0])
    ans
}

rzanegbin = function(n, p0, size, prob=NULL, munb=NULL) {
    if (length(munb)) {
        if (length(prob))
            stop("'prob' and 'munb' both specified")
        prob <- size/(size + munb)
    }
    ans = rposnegbin(n, prob=prob, size=size)
    p0 = rep(p0, len=length(ans))
    if(!is.Numeric(p0) || any(p0 < 0) || any(p0 > 1))
        stop("'p0' must be between 0 and 1 inclusive")
    ifelse(runif(n) < p0, 0, ans)
}





dzapois = function(x, lambda, p0=0, log=FALSE) {
    if(!is.logical(log.arg <- log)) stop("bad input for 'log'")
    rm(log)

    L = max(length(x), length(lambda), length(p0))
    x = rep(x, len=L); lambda = rep(lambda, len=L); p0 = rep(p0, len=L);
    ans = rep(0.0, len=L)
    if(!is.Numeric(p0) || any(p0 < 0) || any(p0 > 1))
        stop("'p0' must be in [0,1]")
    index0 = x==0

    if(log.arg) {
        ans[ index0] = log(p0[index0])
        ans[!index0] = log1p(-p0[!index0]) +
                       dpospois(x[!index0], lambda[!index0], log=TRUE)
    } else {
        ans[ index0] = p0[index0]
        ans[!index0] = (1-p0[!index0]) * dpospois(x[!index0], lambda[!index0])
    }
    ans
}



pzapois = function(q, lambda, p0=0) {
    L = max(length(q), length(lambda), length(p0))
    q = rep(q, len=L); lambda = rep(lambda, len=L); p0 = rep(p0, len=L);
    ans = rep(0.0, len=L)

    if(!is.Numeric(p0) || any(p0 < 0) || any(p0 > 1))
        stop("'p0' must be in [0,1]")
    ans[q >  0] = p0[q > 0] + (1-p0[q > 0]) * ppospois(q[q > 0], lambda[q > 0])
    ans[q <  0] = 0
    ans[q == 0] = p0[q == 0]
    ans
}


qzapois = function(p, lambda, p0=0) {
    nn = max(length(p), length(lambda), length(p0))
    p = rep(p, len=nn); lambda = rep(lambda, len=nn); p0 = rep(p0, len=nn)
    if(!is.Numeric(p0) || any(p0 < 0) || any(p0 > 1))
        stop("'p0' must be between 0 and 1 inclusive")
    ans = p
    ans[p<=p0] = 0
    ans[p>p0] = qpospois((p[p>p0]-p0[p>p0])/(1-p0[p>p0]), lam=lambda[p>p0])
    ans
}

rzapois = function(n, lambda, p0=0) {
    ans = rpospois(n, lambda)
    p0 = rep(p0, len=length(ans))
    if(!is.Numeric(p0) || any(p0 < 0) || any(p0 > 1))
        stop("p0 must be between 0 and 1 inclusive")
    ifelse(runif(n) < p0, 0, ans)
}





dzipois = function(x, lambda, phi=0, log=FALSE) {
    if(!is.logical(log.arg <- log)) stop("bad input for 'log'")
    rm(log)

    L = max(length(x), length(lambda), length(phi))
    x = rep(x, len=L); lambda = rep(lambda, len=L); phi = rep(phi, len=L);
    ans = rep(0.0, len=L)
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("'phi' must be between 0 and 1 inclusive")

    index0 = x==0
    if(log.arg) {
        ans[ index0] = log(phi[index0] + (1-phi[index0]) *
                           dpois(x[index0], lambda[index0]))
        ans[!index0] = log1p(-phi[!index0]) +
                       dpois(x[!index0], lambda[!index0], log=TRUE)
    } else {
        ans[ index0] = phi[index0] + (1-phi[index0]) *
                       dpois(x[index0], lambda[index0])
        ans[!index0] = (1-phi[!index0]) * dpois(x[!index0], lambda[!index0])
    }
    ans
}

pzipois = function(q, lambda, phi=0) {
    ans = ppois(q, lambda)
    phi = rep(phi, length=length(ans))
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("'phi' must be between 0 and 1 inclusive")
    ifelse(x<0, 0, phi + (1-phi) * ans)
}

qzipois = function(p, lambda, phi=0) {
    nn = max(length(p), length(lambda), length(phi))
    p = rep(p, len=nn)
    lambda = rep(lambda, len=nn)
    phi = rep(phi, len=nn)
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("'phi' must be between 0 and 1 inclusive")
    ans = p 
    ans[p<=phi] = 0 
    ans[p>phi] = qpois((p[p>phi]-phi[p>phi])/(1-phi[p>phi]), lam=lambda[p>phi])
    ans
}

rzipois = function(n, lambda, phi=0) {
    if(!is.Numeric(n, positive=TRUE, integer=TRUE, allow=1))
        stop("'n' must be a single positive integer")
    ans = rpois(n, lambda)
    phi = rep(phi, len=length(ans))
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("phi must be between 0 and 1 inclusive")
    ifelse(runif(n) < phi, 0, ans)
}


yip88 = function(link.lambda="loge", n.arg=NULL)
{
    if(mode(link.lambda) != "character" && mode(link.lambda) != "name")
        link.lambda = as.character(substitute(link.lambda))

    new("vglmff",
    blurb=c("Zero-inflated Poisson (based on Yip (1988))\n\n",
           "Link:     ", namesof("lambda", link.lambda), "\n",
           "Variance: (1-phi)*lambda"),
    first=eval(substitute(expression({
        zero <- y==0
        if(any(zero)) {
            if(length(extra)) extra$sumw = sum(w) else
                extra = list(sumw=sum(w))
            if(is.numeric(.n.arg) && extra$sumw != .n.arg) 
                stop(paste("value of n.arg conflicts with data",
                           "(it need not be specified anyway)"))
            warning("trimming out the zero observations")

            axa.save =  attr(x, "assign")
            x = x[!zero,,drop=FALSE]
            attr(x, "assign") = axa.save    # Don't lose these!!
            w = w[!zero]
            y = y[!zero]
        } else 
            if(!is.numeric(.n.arg)) 
                stop("n.arg must be supplied")
        
    }), list( .n.arg=n.arg ))),
    initialize=eval(substitute(expression({
        narg = if(is.numeric(.n.arg)) .n.arg else extra$sumw
        if(sum(w) > narg)
            stop("sum(w) > narg")

        predictors.names = namesof("lambda", .link.lambda, tag=FALSE)
        if(!length(etastart)) {
            lambda.init = rep(median(y), length=length(y))
            etastart = theta2eta(lambda.init, .link.lambda)
        }
        if(length(extra)) {
            extra$sumw = sum(w)
            extra$narg = narg   # For @inverse
        } else 
            extra = list(sumw=sum(w), narg = narg)
    }), list( .link.lambda=link.lambda, .n.arg=n.arg ))),
    inverse=eval(substitute(function(eta, extra=NULL) {
        lambda = eta2theta(eta, .link.lambda)
        temp5 = exp(-lambda)
        phi = (1 - temp5 - extra$sumw/extra$narg) / (1 - temp5)
        if(any(phi <= 0))
            stop("non-positive value(s) of phi")
        (1-phi) * lambda
    }, list( .link.lambda=link.lambda ))),
    last=eval(substitute(expression({
        misc$link = c(lambda = .link.lambda)

        if(ncol(x)==1 && dimnames(x)[[2]]=="(Intercept)") {
            suma = extra$sumw
            phi = (1 - temp5[1] - suma/narg) / (1 - temp5[1])
            phi = if(phi < 0 || phi>1) NA else phi  # phi is a probability
            misc$phi = phi
        }
    }), list( .link.lambda=link.lambda ))),
    loglikelihood=eval(substitute( 
        function(mu,y,w,residuals=FALSE, eta, extra=NULL) {
        lambda = eta2theta(eta, .link.lambda)
        lstar = -lambda + y * log(lambda) - log1p(-exp(-lambda))
        sum(w * lstar)
    }, list( .link.lambda=link.lambda ))),
    vfamily=c("yip88"),
    deriv=eval(substitute(expression({
        lambda = eta2theta(eta, .link.lambda)
        temp5 = exp(-lambda)
        dl.dlambda = -1 + y/lambda - temp5/(1-temp5)
        dlambda.deta = dtheta.deta(lambda, .link.lambda)
        w * dl.dlambda * dlambda.deta
    }), list( .link.lambda=link.lambda ))),
    weight=eval(substitute(expression({
        d2lambda.deta2 = d2theta.deta2(lambda, .link.lambda)
        d2l.dlambda2 = -y / lambda^2 + temp5 / (1-temp5)^2
        -w * (d2l.dlambda2*dlambda.deta^2 + dl.dlambda*d2lambda.deta2)
    }), list( .link.lambda=link.lambda ))))
}




 zapoisson = function(lp0="logit", llambda="loge",
                      ep0=list(), elambda=list(),
                      zero=NULL)
{
    if(mode(lp0) != "character" && mode(lp0) != "name")
        lp0 = as.character(substitute(lp0))
    if(mode(llambda) != "character" && mode(llambda) != "name")
        llambda = as.character(substitute(llambda))
    if(!is.list(ep0)) ep0 = list()
    if(!is.list(elambda)) elambda = list()

    new("vglmff",
    blurb=c(
  "Zero-altered Poisson (binomial and positive-Poisson conditional model)\n\n",
           "Links:    ",
           namesof("p0", lp0, earg=ep0, tag=FALSE), ", ",
           namesof("lambda", llambda, earg= elambda, tag=FALSE),
           "\n"),
    constraints=eval(substitute(expression({
        temp752 = .zero
        if(length(temp752) && all(temp752 == -1))
            temp752 = 2*(1:ncol(y)) - 1
        constraints = cm.zero.vgam(constraints, x, temp752, M)
    }), list( .zero=zero ))),
    initialize=eval(substitute(expression({
        y = as.matrix(y)
        if(any(y != round(y )))
            stop("the response must be integer-valued")
        if(any(y < 0))
            stop("the response must not have negative values")

        extra$y0 = y0 = ifelse(y==0, 1, 0)
        extra$NOS = NOS = ncoly = ncol(y)  # Number of species
        extra$skip.these = skip.these = matrix(as.logical(y0), n, NOS)

        mynames1 = if(ncoly==1) "p0" else paste("p0", 1:ncoly, sep="")
        mynames2 = if(ncoly==1) "lambda" else paste("lambda", 1:ncoly, sep="")
        predictors.names = 
            c(namesof(mynames1, .lp0, earg= .ep0, tag=FALSE),
              namesof(mynames2, .llambda, earg= .elambda, tag=FALSE))
        if(!length(etastart)) {
            etastart = cbind(theta2eta((0.5+w*y0)/(1+w), .lp0, earg= .ep0 ),
                             matrix(1, n, NOS))  # 1 here is any old value
            for(spp. in 1:NOS)
                etastart[!skip.these[,spp.],NOS+spp.] =
                    theta2eta(y[!skip.these[,spp.],spp.] /
                              (1-exp(-y[!skip.these[,spp.],spp.])), .llambda,
                              earg= .elambda )
        }
    }), list( .lp0=lp0, .llambda=llambda, .ep0= ep0, .elambda= elambda ))), 
    inverse=eval(substitute(function(eta, extra=NULL) {
        NOS = extra$NOS
        p0 = eta2theta(eta[,1:NOS], .lp0, earg= .ep0)
        lambda = eta2theta(eta[,NOS+(1:NOS)], .llambda, earg= .elambda)
        (1-p0) * (lambda / (1-exp(-lambda)))
    }, list( .lp0=lp0, .llambda=llambda, .ep0= ep0, .elambda= elambda ))),
    last=eval(substitute(expression({
        misc$link = c(rep( .lp0, len=NOS), rep( .llambda, len=NOS))
        names(misc$link) = c(mynames1, mynames2)
        misc$earg = vector("list", 2*NOS)
        names(misc$earg) = c(mynames1, mynames2)
        for(ii in 1:NOS) {
            misc$earg[[      ii]] = .ep0
            misc$earg[[NOS + ii]] = .elambda
        }
    }), list( .lp0=lp0, .llambda=llambda, .ep0= ep0, .elambda= elambda ))),
    loglikelihood=eval(substitute(
        function(mu,y,w,residuals=FALSE, eta,extra=NULL) {
        NOS = extra$NOS
        p0 = cbind(eta2theta(eta[,1:NOS], .lp0, earg= .ep0))
        lambda = cbind(eta2theta(eta[,NOS+(1:NOS)], .llambda, earg= .elambda ))
        sum(w * dzapois(x=y, p0=p0, lambda=lambda, log=TRUE))
    }, list( .lp0=lp0, .llambda=llambda, .ep0= ep0, .elambda= elambda ))),
    vfamily=c("zapoisson"),
    deriv=eval(substitute(expression({
        NOS = extra$NOS
        y0 = extra$y0
        skip = extra$skip.these
        p0 = cbind(eta2theta(eta[,1:NOS], .lp0, earg= .ep0))
        lambda = cbind(eta2theta(eta[,NOS+(1:NOS)], .llambda, earg= .ep0))
        dl.dlambda = y/lambda - 1 - 1/(exp(lambda)-1)
        for(spp. in 1:NOS)
            dl.dlambda[skip[,spp.],spp.] = 0
        dlambda.deta = dtheta.deta(lambda, .llambda, earg= .ep0)
        mup0 = p0
        temp3 = if(.lp0 == "logit") {
            w * (y0 - mup0)
        } else
            w * dtheta.deta(mup0, link=.lp0, earg= .ep0) * (y0/mup0 - 1) / (1-mup0)
        ans = cbind(temp3, w * dl.dlambda * dlambda.deta)
        ans
    }), list( .lp0=lp0, .llambda=llambda, .ep0= ep0, .elambda= elambda ))),
    weight=eval(substitute(expression({
        wz = matrix( 10 * .Machine$double.eps^(3/4), n, 2*NOS)
        for(spp. in 1:NOS) {
            temp4 = exp(lambda[!skip[,spp.], spp.])
            ed2l.dlambda2 = -temp4 * (1/lambda[!skip[,spp.],spp.] -
                            1/(temp4-1)) / (temp4-1)
            wz[!skip[,spp.],NOS+spp.] = -w[!skip[,spp.]] *
                                      (dlambda.deta[!skip[,spp.],spp.]^2) *
                                      ed2l.dlambda2
        }

        tmp100 = mup0*(1-mup0)
        tmp200 = if( .lp0 == "logit") {
            cbind(w * tmp100)
        } else {
            cbind(w * dtheta.deta(mup0, link= .lp0, earg= .ep0)^2 / tmp100)
        }
        for(ii in 1:NOS) {
            index200 = abs(tmp200[,ii]) < .Machine$double.eps
            if(any(index200)) {
                tmp200[index200,ii] = 10.0 * .Machine$double.eps^(3/4)
            }
        }
        wz[,1:NOS] =  tmp200
        wz
    }), list( .lp0=lp0, .llambda=llambda, .ep0= ep0, .elambda= elambda ))))
}



 zanegbinomial = function(lp0="logit", lmunb = "loge", lk = "loge",
                          ep0=list(), emunb =list(), ek = list(),
                          ipnb0 = NULL, ik = NULL, zero = -3,
                          cutoff = 0.995, method.init=1,
                          shrinkage.init=0.95)
{



    if(!is.Numeric(cutoff, positiv=TRUE, allow=1) || cutoff<0.8 || cutoff>=1)
        stop("range error in the argument cutoff")
    if(length(ipnb0) && (!is.Numeric(ipnb0, positiv=TRUE) ||
       max(ipnb0) >= 1))
        stop("If given, ipnb0 must contain values in (0,1) only")
    if(length(ik) && !is.Numeric(ik, positiv=TRUE))
        stop("If given, ik must contain positive values only")
    if(!is.Numeric(method.init, allow=1, integ=TRUE, posit=TRUE) ||
       method.init > 2) stop("argument \"method.init\" must be 1 or 2")
    if(!is.Numeric(shrinkage.init, allow=1) || shrinkage.init < 0 ||
       shrinkage.init > 1) stop("bad input for argument \"shrinkage.init\"")

    if(mode(lmunb) != "character" && mode(lmunb) != "name")
        lmunb = as.character(substitute(lmunb))
    if(mode(lk) != "character" && mode(lk) != "name")
        lk = as.character(substitute(lk))
    if(mode(lp0) != "character" && mode(lp0) != "name")
        lp0 = as.character(substitute(lp0))
    if(!is.list(ep0)) ep0 = list()
    if(!is.list(emunb)) emunb = list()
    if(!is.list(ek)) ek = list()

    new("vglmff",
    blurb=c("Zero-altered negative binomial (binomial and\n",
            "positive-negative binomial conditional model)\n\n",
           "Links:    ",
           namesof("p0", lp0, earg= ep0, tag=FALSE), ", ",
           namesof("munb", lmunb, earg= emunb, tag=FALSE), ", ",
           namesof("k", lk, earg= ek, tag=FALSE), "\n",
           "Mean:     (1-p0) * munb / [1 - (k/(k+munb))^k]"),
    constraints=eval(substitute(expression({
        temp752 = .zero
        if(length(temp752) && all(temp752 == -3))
            temp752 = 3*(1:ncol(y))
        constraints = cm.zero.vgam(constraints, x, temp752, M)
    }), list( .zero=zero ))),
    initialize=eval(substitute(expression({
        y = as.matrix(y)
        extra$NOS = NOS = ncoly = ncol(y)  # Number of species
        M = 3 * ncoly # 
        if(any(y != round(y)))
            stop("the response must be integer-valued")
        if(any(y < 0))
            stop("the response must not have negative values")

        mynames1 = if(NOS==1) "p0" else paste("p0", 1:NOS, sep="")
        mynames2 = if(NOS==1) "munb" else paste("munb", 1:NOS, sep="")
        mynames3 = if(NOS==1) "k" else paste("k", 1:NOS, sep="")
        predictors.names =
            c(namesof(mynames1, .lp0, earg= .ep0, tag= FALSE),
              namesof(mynames2, .lmunb, earg= .emunb, tag= FALSE),
              namesof(mynames3, .lk, earg= .ek, tag= FALSE))
        predictors.names = predictors.names[interleave.VGAM(3*NOS, M=3)]
        extra$y0 = y0 = ifelse(y==0, 1, 0)
        extra$skip.these = skip.these = matrix(as.logical(y0), n, NOS)

        if(!length(etastart)) {
            mu.init = y
            for(iii in 1:ncol(y)) {
                index.posy = (y[,iii] > 0)
                use.this = if( .method.init == 2) {
                    weighted.mean(y[index.posy,iii], w[index.posy])
                } else {
                    median(rep(y[index.posy,iii], w[index.posy])) + 1/2
                }
                mu.init[ index.posy,iii] = (1- .sinit) * y[index.posy,iii] +
                                           .sinit * use.this
                mu.init[!index.posy,iii] = use.this
                max.use.this =  7 * use.this + 10
                vecTF = (mu.init[,iii] > max.use.this)
                if(any(vecTF))
                    mu.init[vecTF,iii] = max.use.this
            }


            pnb0 = matrix(if(length( .ipnb0)) .ipnb0 else -1,
                          nr=n, nc=NOS, byrow=TRUE)
            for(spp. in 1:NOS) {
                if(any(pnb0[,spp.] < 0)) {
                    index.y0 = y[,spp.] < 0.5
                    pnb0[,spp.] = max(min(sum(index.y0)/n, 0.97), 0.03)
                }
            }


            if( is.Numeric( .ik )) {
                kmat0 = matrix( .ik, nr=n, nc=ncoly, byrow=TRUE)
            } else {
                posnegbinomial.Loglikfun = function(kmat, y, x, w, extraargs) {
                     munb = extraargs
                     sum(w * dposnegbin(x=y, munb=munb, size=kmat, log=TRUE))
                }
                k.grid = 2^((-6):6)
                kmat0 = matrix(0, nr=n, nc=NOS) 
                for(spp. in 1:NOS) {
                    index.posy = y[,spp.] > 0
                    posy = y[index.posy, spp.]
                    kmat0[,spp.] = getMaxMin(k.grid,
                                      objfun=posnegbinomial.Loglikfun,
                                      y=posy, x=x[index.posy,], w=w[index.posy],
                                      extraargs= mu.init[index.posy, spp.])
                }
            }

            etastart = cbind(theta2eta(pnb0,    .lp0,   earg= .ep0 ),
                             theta2eta(mu.init, .lmunb, earg= .emunb),
                             theta2eta(kmat0,   .lk,    earg= .ek ))
            etastart = etastart[,interleave.VGAM(ncol(etastart),M=3)]
        }
    }), list( .lp0=lp0, .lmunb=lmunb, .lk=lk,
              .ipnb0=ipnb0, .ik=ik,
              .ep0=ep0, .emunb=emunb, .ek=ek,
              .method.init=method.init, .sinit=shrinkage.init ))), 
    inverse=eval(substitute(function(eta, extra=NULL) {
        NOS = extra$NOS
        p0 = eta2theta(eta[,3*(1:NOS)-2], .lp0, earg= .ep0 )
        munb = eta2theta(eta[,3*(1:NOS)-1,drop=FALSE], .lmunb, earg= .emunb )
        kmat = eta2theta(eta[,3*(1:NOS),drop=FALSE], .lk, earg= .ek )
        pnb0 = (kmat / (kmat + munb))^kmat # p(0) from negative binomial
        (1 - p0) * munb / (1 - pnb0)
    }, list( .lp0=lp0, .lk=lk, .lmunb=lmunb,
             .ep0=ep0, .emunb=emunb, .ek=ek ))),
    last=eval(substitute(expression({
        misc$link = c(rep( .lp0, length=NOS),
                      rep( .lmunb, length=NOS),
                      rep( .lk, length=NOS))
        temp.names = c(mynames1, mynames2, mynames3)
        temp.names = temp.names[interleave.VGAM(3*NOS, M=3)]
        names(misc$link) = temp.names
        misc$earg = vector("list", 3*NOS)
        names(misc$earg) = temp.names
        for(ii in 1:NOS) {
            misc$earg[[3*ii-2]] = .ep0
            misc$earg[[3*ii-1]] = .emunb
            misc$earg[[3*ii  ]] = .ek
        }
        misc$cutoff = .cutoff
        misc$method.init = .method.init
    }), list( .lp0=lp0, .lmunb=lmunb, .lk=lk, .cutoff=cutoff,
              .ep0=ep0, .emunb=emunb, .ek=ek,
              .method.init=method.init ))),
    loglikelihood=eval(substitute(
        function(mu,y,w,residuals=FALSE, eta,extra=NULL) {
        NOS = extra$NOS
        p0 = eta2theta(eta[,3*(1:NOS)-2,drop=FALSE], .lp0, earg= .ep0 )
        munb = eta2theta(eta[,3*(1:NOS)-1,drop=FALSE], .lmunb, earg= .emunb )
        kmat = eta2theta(eta[,3*(1:NOS),drop=FALSE], .lk, earg= .ek )
        sum(w * dzanegbin(x=y, p0=p0, munb=munb, size=kmat, log=TRUE))
    }, list( .lp0=lp0, .lmunb=lmunb, .lk=lk,
             .ep0=ep0, .emunb=emunb, .ek=ek ))),
    vfamily=c("zanegbinomial"),
    deriv=eval(substitute(expression({
        NOS = extra$NOS
        y0 = extra$y0
        p0 = eta2theta(eta[,3*(1:NOS)-2], .lp0, earg= .ep0 )
        munb = eta2theta(eta[,3*(1:NOS)-1,drop=FALSE], .lmunb, earg= .emunb )
        kmat = eta2theta(eta[,3*(1:NOS),drop=FALSE], .lk, earg= .ek )
        skip = extra$skip.these

        d3 = deriv3(~ -log(1 - (kmat. /(kmat. + munb. ))^kmat. ),
                    c("munb.", "kmat."), hessian= TRUE) # Extra term
        dl0.dthetas =  array(NA, c(n, NOS, 2))
        d2l0.dthetas2 =  array(NA, c(n, NOS, 3))  # matrix-band format
        for(spp. in 1:NOS) {
            kmat. = kmat[,spp.]
            munb. = munb[,spp.]
            eval.d3 = eval(d3)  # Evaluated for one species
            dl0.dthetas[,spp.,1] =  attr(eval.d3, "gradient")[,1]
            dl0.dthetas[,spp.,2] =  attr(eval.d3, "gradient")[,2]
            d2l0.dthetas2[,spp.,1] =  attr(eval.d3, "hessian")[,1,1]
            d2l0.dthetas2[,spp.,2] =  attr(eval.d3, "hessian")[,2,2]
            d2l0.dthetas2[,spp.,3] =  attr(eval.d3, "hessian")[,1,2]
        }
        dl.dmunb = y/munb - (y+kmat)/(kmat+munb) + dl0.dthetas[,,1]  
        dl.dk = digamma(y+kmat) - digamma(kmat) - (y+kmat)/(munb+kmat) + 1 +
                log(kmat/(kmat+munb)) + dl0.dthetas[,,2]  
        for(spp. in 1:NOS)
            dl.dk[skip[,spp.],spp.] = dl.dmunb[skip[,spp.],spp.] = 0

        dmunb.deta = dtheta.deta(munb, .lmunb, earg= .emunb )
        dk.deta = dtheta.deta(kmat, .lk, earg= .ek )
        myderiv = w * cbind(dl.dmunb * dmunb.deta, dl.dk * dk.deta)

        mup0 = p0
        temp3 = if( .lp0 == "logit") {
            w * (y0 - mup0)
        } else
            w * dtheta.deta(mup0, link= .lp0, earg= .ep0 ) *
                (y0/mup0 - 1) / (1-mup0)

        ans = cbind(temp3, myderiv)
        ans = ans[,interleave.VGAM(ncol(ans), M=3)]
        ans
    }), list( .lp0=lp0, .lmunb=lmunb, .lk=lk,
              .ep0=ep0, .emunb=emunb, .ek=ek ))),
    weight=eval(substitute(expression({
        wz = matrix(0, n, 6*NOS-1)  # wz is not 'diagonal' 
        pnb0 = (kmat / (kmat + munb))^kmat
        ed2l.dmunb2 = (1/munb - (munb + kmat*(1-pnb0))/(munb +
                       kmat)^2) / (1-pnb0) - d2l0.dthetas2[,,1]
        wz[,3*(1:NOS)-1] = w * dmunb.deta^2 * ed2l.dmunb2
        wz[,3*NOS+3*(1:NOS)-1] = -w * d2l0.dthetas2[,,3] * dmunb.deta * dk.deta



        fred = dotFortran(name="enbin8",
                      ans=double(n*NOS), as.double(kmat),
                      as.double(kmat/(munb+kmat)), as.double(.cutoff),
                      as.integer(n), ok=as.integer(1), as.integer(NOS),
                      sumpdf=double(1), macheps=as.double(.Machine$double.eps))
        if(fred$ok != 1)
            stop("error in Fortran subroutine exnbin")
        dim(fred$ans) = c(n, NOS)
        ed2l.dk2 = -fred$ans/(1-pnb0) - 1/kmat + 1/(kmat+munb) -
                   munb * pnb0 / ((1-pnb0)*(munb+kmat)^2) - d2l0.dthetas2[,,2]
        wz[,3*(1:NOS)] = w * dk.deta^2 * ed2l.dk2




        tmp100 = mup0*(1-mup0)
        tmp200 = if(.lp0 == "logit") {
            cbind(w * tmp100)
        } else {
            cbind(w * dtheta.deta(mup0, link= .lp0, earg= .ep0 )^2 / tmp100)
        }
        for(ii in 1:NOS) {
            index200 = abs(tmp200[,ii]) < .Machine$double.eps
            if(any(index200)) {
                tmp200[index200,ii] = .Machine$double.eps # Diagonal 0's are bad 
            }
        }
        wz[,3*(1:NOS)-2] =  tmp200

        for(spp. in 1:NOS) {
            wz[skip[,spp.],3*spp. - 1] = 
            wz[skip[,spp.],3*spp.] = sqrt(.Machine$double.eps)
            wz[skip[,spp.],3*NOS+3*(spp.)-1] = 0
        }

        wz
    }), list( .lp0=lp0, .ep0=ep0, .cutoff=cutoff ))))
}




if(FALSE)
rposnegbin = function(n, munb, k) {
    if(!is.Numeric(k, posit=TRUE))
        stop("argument \"k\" must be positive")
    if(!is.Numeric(munb, posit=TRUE))
        stop("argument \"munb\" must be positive")
    if(!is.Numeric(n, posit=TRUE, integ=TRUE, allow=1))
        stop("argument \"n\" must be a positive integer")
    ans = rnbinom(n=n, mu=munb, size=k)
    munb = rep(munb, len=n)
    k = rep(k, len=n)
    index = ans == 0
    while(any(index)) {
        more = rnbinom(n=sum(index), mu=munb[index], size=k[index])
        ans[index] = more
        index = ans == 0
    }
    ans
}



if(FALSE)
dposnegbin = function(x, munb, k, log=FALSE) {
    if(!is.Numeric(k, posit=TRUE))
        stop("argument \"k\" must be positive")
    if(!is.Numeric(munb, posit=TRUE))
        stop("argument \"munb\" must be positive")
    ans = dnbinom(x=x, mu=munb, size=k, log=log)
    ans0 = dnbinom(x=0, mu=munb, size=k, log=FALSE)
    ans = if(log) ans - log1p(-ans0) else ans/(1-ans0)
    ans[x == 0] = if(log) -Inf else 0
    ans
}



 zipoisson = function(lphi="logit", llambda="loge",
                      ephi=list(), elambda =list(),
                      iphi=NULL, method.init=1,
                      shrinkage.init=0.8, zero=NULL)
{
    if(mode(lphi) != "character" && mode(lphi) != "name")
        lphi = as.character(substitute(lphi))
    if(mode(llambda) != "character" && mode(llambda) != "name")
        llambda = as.character(substitute(llambda))
    if(is.Numeric(iphi))
        if(!is.Numeric(iphi, allow=1, posit=TRUE) || iphi >= 1)
            stop("iphi must be a single number inside the interval (0,1)")
    if(!is.list(ephi)) ephi = list()
    if(!is.list(elambda)) elambda = list()
    if(!is.Numeric(method.init, allow=1, integ=TRUE, posit=TRUE) ||
       method.init > 2) stop("argument \"method.init\" must be 1 or 2")
    if(!is.Numeric(shrinkage.init, allow=1) || shrinkage.init < 0 ||
       shrinkage.init > 1) stop("bad input for argument \"shrinkage.init\"")

    new("vglmff",
    blurb=c("Zero-inflated Poisson\n\n",
            "Links:    ", namesof("phi", lphi, earg= ephi), ", ",
            namesof("lambda", llambda, earg= elambda), "\n",
            "Mean:     (1-phi)*lambda"),
    constraints=eval(substitute(expression({
        constraints <- cm.zero.vgam(constraints, x, .zero, M)
    }), list( .zero=zero ))),
    initialize=eval(substitute(expression({
        if(ncol(as.matrix(y)) != 1) stop("multivariate responses not allowed")
        if(any(round(y) != y))
          stop("integer-valued responses only allowed for the zipoisson family")
        predictors.names = c(
            namesof("phi", .lphi, earg= .ephi, tag=FALSE),
            namesof("lambda", .llambda, earg= .ephi, tag=FALSE))
        if(!length(etastart)) {
            phi.init = if(length( .iphi)) .iphi else {
                sum(w[y==0]) / sum(w)
            }
            phi.init[phi.init <= 0.02] = 0.02  # Last resort
            phi.init[phi.init >= 0.98] = 0.98  # Last resort
            if( .method.init == 2) {
                mymean = weighted.mean(y[y>0], w[y>0]) + 1/16
                lambda.init = (1- .sinit) * (y+1/8) + .sinit * mymean
            } else {
                use.this = median(y[y>0]) + 1/16
                lambda.init = (1- .sinit) * (y+1/8) + .sinit * use.this
            }
            etastart = cbind(theta2eta(rep(phi.init, len=n), .lphi, earg= .ephi ),
                             theta2eta(lambda.init, .llambda, earg= .ephi ))
        }
    }), list( .lphi=lphi, .llambda=llambda,
              .ephi=ephi, .elambda=elambda,
              .method.init=method.init,
              .iphi=iphi,
              .sinit=shrinkage.init ))),
    inverse=eval(substitute(function(eta, extra=NULL) {
        phi = eta2theta(eta[,1], .lphi, earg= .ephi )
        lambda = eta2theta(eta[,2], .llambda, earg= .elambda )
        (1-phi) * lambda
    }, list( .lphi=lphi, .llambda=llambda,
             .ephi=ephi, .elambda=elambda ))),
    last=eval(substitute(expression({
        misc$link <- c("phi" = .lphi, "lambda" = .llambda)
        misc$earg <- list("phi" = .ephi, "lambda" = .elambda)
        if(intercept.only) {
            phi = eta2theta(eta[1,1], .lphi, earg= .ephi )
            lambda = eta2theta(eta[1,2], .llambda, earg= .elambda )
            misc$prob0 = phi + (1-phi) * exp(-lambda) # P(Y=0)
        }
    }), list( .lphi=lphi, .llambda=llambda,
              .ephi=ephi, .elambda=elambda ))),
    loglikelihood=eval(substitute( 
        function(mu,y,w,residuals=FALSE, eta, extra=NULL) {
        smallno = 100 * .Machine$double.eps
        phi = eta2theta(eta[,1], .lphi, earg= .ephi )
        phi = pmax(phi, smallno)
        phi = pmin(phi, 1.0-smallno)
        lambda = eta2theta(eta[,2], .llambda, earg= .elambda )
        sum(w * dzipois(x=y, phi=phi, lambda=lambda, log=TRUE))
    }, list( .lphi=lphi, .llambda=llambda,
             .ephi=ephi, .elambda=elambda ))),
    vfamily=c("zipoisson"),
    deriv=eval(substitute(expression({
        smallno = 100 * .Machine$double.eps
        phi = eta2theta(eta[,1], .lphi, earg= .ephi )
        phi = pmax(phi, smallno)
        phi = pmin(phi, 1.0-smallno)
        lambda = eta2theta(eta[,2], .llambda, earg= .elambda )
        tmp8 = phi + (1-phi)*exp(-lambda)
        index0 = (y==0)
        dl.dphi = (1-exp(-lambda)) / tmp8
        dl.dphi[!index0] = -1 / (1-phi[!index0])
        dl.dlambda = -(1-phi) * exp(-lambda) / tmp8
        dl.dlambda[!index0] = (y[!index0] - lambda[!index0]) / lambda[!index0]
        dphi.deta = dtheta.deta(phi, .lphi, earg= .ephi)
        dlambda.deta = dtheta.deta(lambda, .llambda, earg= .elambda )
        ans = w * cbind(dl.dphi * dphi.deta, dl.dlambda * dlambda.deta)
        if(.llambda == "loge" && (any(lambda[!index0] < .Machine$double.eps))) {
            ans[!index0,2] = w[!index0] * (y[!index0] - lambda[!index0])
        }
        ans
    }), list( .lphi=lphi, .llambda=llambda,
              .ephi=ephi, .elambda=elambda ))),
    weight=eval(substitute(expression({
        wz = matrix(as.numeric(NA), nrow=n, ncol=dimm(M))
        d2l.dphi2 = (1-exp(-lambda)) / ((1-phi)*tmp8)
        d2l.dlambda2 = (1-phi)/lambda - phi*(1-phi)*exp(-lambda) / tmp8
        d2l.dphilambda = -exp(-lambda) / tmp8
        wz[,iam(1,1,M)] = d2l.dphi2 * dphi.deta^2
        wz[,iam(2,2,M)] = d2l.dlambda2 * dlambda.deta^2
        wz[,iam(1,2,M)] = d2l.dphilambda * dphi.deta * dlambda.deta
        if(.llambda == "loge" && (any(lambda[!index0] < .Machine$double.eps))) {
            ind5 = !index0 & (lambda < .Machine$double.eps)
            if(any(ind5))
                wz[ind5,iam(2,2,M)] = (1-phi[ind5]) * .Machine$double.eps
        }
        w * wz
    }), list( .lphi=lphi, .llambda=llambda,
              .ephi=ephi, .elambda=elambda ))))
}



 zibinomial = function(lphi="logit", link.mu="logit",
                       ephi=list(), emu=list(),
                       iphi=NULL, zero=1, mv=FALSE)
{
    if(as.logical(mv)) stop("argument \"mv\" must be FALSE")
    if(mode(lphi) != "character" && mode(lphi) != "name")
        lphi = as.character(substitute(lphi))
    if(mode(link.mu) != "character" && mode(link.mu) != "name")
        link.mu = as.character(substitute(link.mu))
    if(is.Numeric(iphi))
        if(!is.Numeric(iphi, allow=1, posit=TRUE) || iphi >= 1)
            stop("iphi must be a single number inside the interval (0,1)")
    if(!is.list(ephi)) ephi = list()
    if(!is.list(emu)) emu = list()

    new("vglmff",
    blurb=c("Zero-inflated binomial\n\n",
            "Links:    ", namesof("phi", lphi, earg= ephi ), ", ",
            namesof("mu", link.mu, earg= emu ), "\n",
            "Mean:     (1-phi) * mu / (1 - (1-mu)^w)"),
    constraints=eval(substitute(expression({
        constraints <- cm.zero.vgam(constraints, x, .zero, M)
    }), list( .zero=zero ))),
    initialize=eval(substitute(expression({
        {
            NCOL = function (x)
                if(is.array(x) && length(dim(x)) > 1 ||
                is.data.frame(x)) ncol(x) else as.integer(1)

            if(NCOL(y) == 1) {
                if(is.factor(y)) y = y != levels(y)[1]
                nn = rep(1, n)
                if(!all(y >= 0 & y <= 1))
                    stop("response values must be in [0, 1]")
                mustart = (0.5 + w * y) / (1 + w)
                no.successes = w * y
                if(any(abs(no.successes - round(no.successes)) > 0.001))
                    stop("Number of successes must be integer-valued")
            } else if(NCOL(y) == 2) {
                if(any(abs(y - round(y)) > 0.001))
                    stop("Count data must be integer-valued")
                nn = y[,1] + y[,2]
                y = ifelse(nn > 0, y[,1]/nn, 0)
                w = w * nn
                mustart = (0.5 + nn * y) / (1 + nn)
            } else
                stop("Response not of the right form (1 or 2 columns required)")
        }

        predictors.names = c( namesof("phi", .lphi, earg= .ephi, tag=FALSE),
                              namesof("mu",  .link.mu, earg= .emu, tag=FALSE))
        phi.init = if(length( .iphi)) .iphi else {
            sum(w[y==0]) / sum(w)
        }
        if(phi.init <= 0 || phi.init >=1) phi.init = 0.1  # Last resort
        mustart = cbind(rep(phi.init, len=n), mustart) # 1st coln not a real mu
    }), list( .lphi=lphi, .link.mu=link.mu,
              .ephi=ephi, .emu=emu,
              .iphi=iphi ))),
    inverse=eval(substitute(function(eta, extra=NULL) {
        phi = eta2theta(eta[,1], .lphi, earg= .ephi )
        mubin = eta2theta(eta[,2], .link.mu, earg= .emu )
        (1-phi) * mubin
    }, list( .lphi=lphi, .link.mu=link.mu,
             .ephi=ephi, .emu=emu ))),
    last=eval(substitute(expression({
        misc$link <- c("phi" = .lphi, "mu" = .link.mu)
        misc$earg <- list("phi" = .ephi, "mu" = .emu )
        if(intercept.only && all(w==w[1])) {
            phi = eta2theta(eta[1,1], .lphi, earg= .ephi )
            mubin = eta2theta(eta[1,2], .link.mu, earg= .emu )
            misc$p0 = phi + (1-phi) * (1-mubin)^w[1] # P(Y=0)
        }
    }), list( .lphi=lphi, .link.mu=link.mu,
              .ephi=ephi, .emu=emu ))),
    link=eval(substitute(function(mu, extra=NULL)
        cbind(theta2eta(mu[,1], .lphi, earg= .ephi ),
              theta2eta(mu[,2], .link.mu, earg= .emu ))
    , list( .lphi=lphi, .link.mu=link.mu,
            .ephi=ephi, .emu=emu ))),
    loglikelihood=eval(substitute( 
        function(mu,y,w,residuals=FALSE, eta, extra=NULL) {
        phi = eta2theta(eta[,1], .lphi, earg= .ephi )
        mubin = eta2theta(eta[,2], .link.mu, earg= .emu )
        index = (y==0)
        tmp8 = phi + (1-phi)*(1-mubin)^w
        ell0 = log(tmp8[index])
        ell1 = log1p(-phi[!index]) + dbinom(x=round(w[!index]*y[!index]), 
               size=w[!index], prob=mubin[!index], log=TRUE)
        sum(ell0) + sum(ell1)
    }, list( .lphi=lphi, .link.mu=link.mu,
             .ephi=ephi, .emu=emu ))),
    vfamily=c("zibinomial"),
    deriv=eval(substitute(expression({
        phi = eta2theta(eta[,1], .lphi, earg= .ephi )
        mubin = eta2theta(eta[,2], .link.mu, earg= .emu )
        prob0 = (1-mubin)^w    # Actually q^w
        tmp8 = phi + (1-phi)*prob0
        index = (y==0)
        dl.dphi = (1-prob0) / tmp8
        dl.dphi[!index] = -1 / (1-phi[!index])
        dl.dmubin = -w * (1-phi) * (1-mubin)^(w-1) / tmp8
        dl.dmubin[!index] = w[!index] * (y[!index]/mubin[!index] - 
            (1-y[!index]) / (1-mubin[!index]))
        dphi.deta = dtheta.deta(phi, .lphi, earg= .ephi )
        dmubin.deta = dtheta.deta(mubin, .link.mu, earg= .emu )
        ans = cbind(dl.dphi * dphi.deta, dl.dmubin * dmubin.deta)
        if(.link.mu == "logit") {
            ans[!index,2] = w[!index] * (y[!index] - mubin[!index])
        }
        ans
    }), list( .lphi=lphi, .link.mu=link.mu,
              .ephi=ephi, .emu=emu ))),
    weight=eval(substitute(expression({
        wz = matrix(as.numeric(NA), nrow=n, ncol=dimm(M))
        d2l.dphi2 = (1-mubin^w) / ((1-phi) * tmp8)
        d2l.dmubin2 = w * (1-phi) * ((1 - mubin * (1-mubin)^(w-1)) / 
                      (mubin*(1-mubin)) - mubin^(w-2) * (w*phi-tmp8) / tmp8)
        d2l.dphimubin = -w * (1-mubin)^(w-1) / tmp8
        wz[,iam(1,1,M)] = d2l.dphi2 * dphi.deta^2
        wz[,iam(2,2,M)] = d2l.dmubin2 * dmubin.deta^2
        wz[,iam(1,2,M)] = d2l.dphimubin * dphi.deta * dmubin.deta
        if(TRUE) {
            ind6 = wz[,iam(2,2,M)] < .Machine$double.eps
            if(any(ind6))
                wz[ind6,iam(2,2,M)] = .Machine$double.eps
        }
        wz
    }), list( .lphi=lphi, .link.mu=link.mu,
              .ephi=ephi, .emu=emu ))))
}



dzibinom = function(x, size, prob, log = FALSE, phi=0) {
    L = max(length(x), length(size), length(prob), length(phi))
    x = rep(x, len=L); size = rep(size, len=L);
    prob = rep(prob, len=L); phi = rep(phi, len=L);
    ans = dbinom(x, size, prob, log=log)
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("phi must be between 0 and 1 inclusive")
    ifelse(x==0, phi + (1-phi) * ans, (1-phi) * ans)
}

pzibinom = function(q, size, prob, lower.tail = TRUE, log.p = FALSE, phi=0) {
    ans = pbinom(q, size, prob, lower.tail = lower.tail, log.p = log.p)
    phi = rep(phi, length=length(ans))
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("phi must be between 0 and 1 inclusive")
    phi + (1-phi) * ans
}

qzibinom = function(p, size, prob, lower.tail = TRUE, log.p = FALSE, phi=0) {
    nn = max(length(p), length(size), length(prob), length(phi))
    p = rep(p, len=nn)
    size = rep(size, len=nn)
    prob = rep(prob, len=nn)
    phi = rep(phi, len=nn)
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("phi must be between 0 and 1 inclusive")
    ans = p 
    ans[p<=phi] = 0 
    ans[p>phi] = qbinom((p[p>phi]-phi[p>phi])/(1-phi[p>phi]), size[p>phi],
                        prob[p>phi], lower.tail = lower.tail, log.p = log.p)
    ans
}

rzibinom = function(n, size, prob, phi=0) {
    if(!is.Numeric(n, positive=TRUE, integer=TRUE, allow=1))
        stop("n must be a single positive integer")
    ans = rbinom(n, size, prob)
    phi = rep(phi, len=length(ans))
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("phi must be between 0 and 1 inclusive")
    ifelse(runif(n) < phi, 0, ans)
}










dzinegbin = function(x, phi, size, prob=NULL, munb=NULL, log=FALSE) {
    if (length(munb)) {
        if (length(prob))
            stop("'prob' and 'munb' both specified")
        prob <- size/(size + munb)
    }
    log.arg = log
    rm(log)
    if(!is.logical(log.arg) || length(log.arg) != 1)
        stop("bad input for 'log.arg'")
    ans = dnbinom(x=x, size=size, prob=prob, log = log.arg)
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("'phi' must be between 0 and 1 inclusive")
    phi = rep(phi, length=length(ans))
    if(log.arg) ifelse(x==0, log(phi+(1-phi)*exp(ans)), log1p(-phi) + ans) else
                ifelse(x==0, phi + (1-phi) * ans, (1-phi) * ans)
}

pzinegbin = function(q, phi, size, prob=NULL, munb=NULL) {
    if (length(munb)) {
        if (length(prob))
            stop("'prob' and 'munb' both specified")
        prob <- size/(size + munb)
    }
    ans = pnbinom(q=q, size=size, prob=prob)
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("'phi' must be between 0 and 1 inclusive")
    phi + (1-phi) * ans
}

qzinegbin = function(p, phi, size, prob=NULL, munb=NULL) {
    if (length(munb)) {
        if (length(prob))
            stop("'prob' and 'munb' both specified")
        prob <- size/(size + munb)
    }
    nn = max(length(p), length(prob), length(phi), length(size))
    p = rep(p, len=nn)
    phi = rep(phi, len=nn)
    prob = rep(prob, len=nn)
    size = rep(size, len=nn)
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("'phi' must be between 0 and 1 inclusive")
    ans = p 
    ans[p<=phi] = 0
    ans[p>phi] = qnbinom(p=(p[p>phi]-phi[p>phi])/(1-phi[p>phi]),
                         size=size[p>phi], prob=prob[p>phi])
    ans
}

rzinegbin = function(n, phi, size, prob=NULL, munb=NULL) {
    if (length(munb)) {
        if (length(prob))
            stop("'prob' and 'munb' both specified")
        prob <- size/(size + munb)
    }
    if(!is.Numeric(n, positive=TRUE, integer=TRUE, allow=1))
        stop("'n' must be a single positive integer")
    ans = rnbinom(n=n, size=size, prob=prob)
    if(!is.Numeric(phi) || any(phi < 0) || any(phi > 1))
        stop("'phi' must be between 0 and 1 inclusive")
    phi = rep(phi, len=length(ans))
    ifelse(runif(n) < phi, rep(0, n), ans)
}




zinegbinomial.control <- function(save.weight=TRUE, ...)
{
    list(save.weight=save.weight)
}



 zinegbinomial = function(lphi="logit", lmunb = "loge", lk = "loge",
                          ephi=list(), emunb =list(), ek = list(),
                          iphi = NULL, ik = NULL, zero = -3, method.init=1,
                          shrinkage.init=0.95,
                          nsimEIM=200)
{


    if(length(iphi) && (!is.Numeric(iphi, positiv=TRUE) || any(iphi >= 1)))
        stop("'iphi' must contain values in (0,1)")
    if(length(ik) && !is.Numeric(ik, positiv=TRUE))
        stop("'ik' must contain positive values only")
    if(!is.Numeric(method.init, allow=1, integ=TRUE, posit=TRUE) ||
       method.init > 3) stop("argument \"method.init\" must be 1, 2 or 3")
    if(!is.Numeric(nsimEIM, allow=1, integ=TRUE))
        stop("'nsimEIM' must be a positive integer")
    if(nsimEIM <= 10)
        warning("'nsimEIM' should be greater than 10, say")
    if(!is.Numeric(shrinkage.init, allow=1) || shrinkage.init < 0 ||
       shrinkage.init > 1) stop("bad input for argument \"shrinkage.init\"")

    if(mode(lmunb) != "character" && mode(lmunb) != "name")
        lmunb = as.character(substitute(lmunb))
    if(mode(lk) != "character" && mode(lk) != "name")
        lk = as.character(substitute(lk))
    if(mode(lphi) != "character" && mode(lphi) != "name")
        lphi = as.character(substitute(lphi))
    if(!is.list(ephi)) ephi = list()
    if(!is.list(emunb)) emunb = list()
    if(!is.list(ek)) ek = list()

    new("vglmff",
    blurb=c("Zero-inflated negative binomial\n\n",
           "Links:    ",
           namesof("phi", lphi, earg= ephi, tag=FALSE), ", ",
           namesof("munb", lmunb, earg= emunb, tag=FALSE), ", ",
           namesof("k", lk, earg= ek, tag=FALSE), "\n",
           "Mean:     (1-phi) * munb"),
    constraints=eval(substitute(expression({
        temp752 = .zero
        if(length(temp752) && all(temp752 == -3))
            temp752 = 3*(1:ncol(y))
        constraints = cm.zero.vgam(constraints, x, temp752, M)
    }), list( .zero=zero ))),
    initialize=eval(substitute(expression({
        y = as.matrix(y)
        extra$NOS = NOS = ncoly = ncol(y)  # Number of species
        if(length(dimnames(y)))
            extra$dimnamesy2 = dimnames(y)[[2]]

        mynames1 = if(NOS==1) "phi" else paste("phi", 1:NOS, sep="")
        mynames2 = if(NOS==1) "munb" else paste("munb", 1:NOS, sep="")
        mynames3 = if(NOS==1) "k" else paste("k", 1:NOS, sep="")
        predictors.names =
            c(namesof(mynames1, .lphi, earg= .ephi, tag= FALSE),
              namesof(mynames2, .lmunb, earg= .emunb, tag= FALSE),
              namesof(mynames3, .lk, earg= .ek, tag= FALSE))
        predictors.names = predictors.names[interleave.VGAM(3*NOS, M=3)]
        if(!length(etastart)) {
            mu.init = if( .method.init == 3) {
                y + 1/16
            } else {
                mu.init = y
                for(iii in 1:ncol(y)) {
                    index = (y[,iii] > 0)
                    mu.init[,iii] = if( .method.init == 2)
                        weighted.mean(y[index,iii], w=w[index]) else
                        median(rep(y[index,iii], w[index])) + 1/8
                }
                (1- .sinit) * (y+1/16) + .sinit * mu.init
            }

            phi.init = if(length( .iphi))
                matrix( .iphi, n, ncoly, byrow=TRUE) else {
                phi.init = y
                for(iii in 1:ncol(y))
                    phi.init[,iii] = sum(w[y[,iii]==0]) / sum(w)
                phi.init[phi.init <= 0.02] = 0.02  # Last resort
                phi.init[phi.init >= 0.98] = 0.98  # Last resort
                phi.init
            }

            kay.init =
            if( is.Numeric( .ik )) {
                matrix( .ik, nr=n, nc=ncoly, byrow=TRUE)
            } else {
                zinegbin.Loglikfun = function(kval, y, x, w, extraargs) {
                    index = (y == 0)
                    phivec = extraargs$phi
                    muvec = extraargs$mu
                    tmp8 = phivec[index] + (1.0-phivec[index]) *
                           dnbinom(y[index], mu= muvec[index], size=kval)
                    ell0 = log(tmp8)
                    ell1 = log1p(-phivec[!index]) + dnbinom(y[!index],
                                mu= muvec[!index], size=kval, log=TRUE)
                    sum(w[index] * ell0) + sum(w[!index] * ell1)
                }
                k.grid = 2^((-6):6)
                kay.init = matrix(0, nr=n, nc=NOS)
                for(spp. in 1:NOS) {
                    kay.init[,spp.] = getMaxMin(k.grid,
                                      objfun=zinegbin.Loglikfun,
                                      y=y[,spp.], x=x, w=w,
                                      extraargs= list(phi=phi.init[,spp.],
                                                      mu=mu.init[,spp.]))
                }
                kay.init
            }

            etastart = cbind(theta2eta(phi.init,  .lphi,  earg= .ephi),
                             theta2eta(mu.init,   .lmunb, earg= .emunb),
                             theta2eta(kay.init, .lk,    earg= .ek))
            etastart = etastart[,interleave.VGAM(ncol(etastart),M=3)]
        }
    }), list( .lphi=lphi, .lmunb=lmunb, .lk=lk, .iphi=iphi, .ik=ik,
              .sinit=shrinkage.init,
              .ephi=ephi, .emunb=emunb, .ek=ek,
              .method.init=method.init ))), 
    inverse=eval(substitute(function(eta, extra=NULL) {
        NOS = extra$NOS
        phi  = eta2theta(eta[,3*(1:NOS)-2,drop=FALSE], .lphi,  earg= .ephi )
        munb = eta2theta(eta[,3*(1:NOS)-1,drop=FALSE], .lmunb, earg= .emunb )
        fv.matrix = (1 - phi) * munb
        if(length(extra$dimnamesy2))
            dimnames(fv.matrix) = list(dimnames(phi)[[1]], extra$dimnamesy2)
        fv.matrix
    }, list( .lphi=lphi, .lk=lk, .lmunb=lmunb,
             .ephi=ephi, .emunb=emunb, .ek=ek ))),
    last=eval(substitute(expression({
        misc$link = c(rep( .lphi, length=NOS), rep( .lmunb, length=NOS),
                      rep( .lk, length=NOS))
        temp.names = c(mynames1, mynames2, mynames3)
        temp.names = temp.names[interleave.VGAM(3*NOS, M=3)]
        names(misc$link) = temp.names
        misc$earg = vector("list", 3*NOS)
        names(misc$earg) = temp.names
        for(ii in 1:NOS) {
            misc$earg[[3*ii-2]] = .ephi
            misc$earg[[3*ii-1]] = .emunb
            misc$earg[[3*ii  ]] = .ek
        }
        misc$method.init = .method.init
        misc$nsimEIM = .nsimEIM
        misc$expected = TRUE
        if(intercept.only) {
            phi  = eta2theta(eta[1,3*(1:NOS)-2], .lphi,  earg= .ephi)
            munb = eta2theta(eta[1,3*(1:NOS)-1], .lmunb, earg= .emunb )
            kval = eta2theta(eta[1,3*(1:NOS)],   .lk, earg= .ek)
            misc$prob0 = phi + (1-phi) * (kval / (kval + munb))^kval # P(Y=0)
        }
    }), list( .lphi=lphi, .lmunb=lmunb, .lk=lk,
              .ephi=ephi, .emunb=emunb, .ek=ek, .nsimEIM=nsimEIM,
              .method.init=method.init ))),
    loglikelihood=eval(substitute(
        function(mu,y,w,residuals=FALSE, eta,extra=NULL) {
        NOS = extra$NOS
        phi  = eta2theta(eta[,3*(1:NOS)-2,drop=FALSE], .lphi,  earg= .ephi )
        munb = eta2theta(eta[,3*(1:NOS)-1,drop=FALSE], .lmunb, earg= .emunb )
        kmat = eta2theta(eta[,3*(1:NOS),  drop=FALSE], .lk,    earg= .ek )
        sum(w*dzinegbin(x=y, phi=phi, munb=munb, size=kmat, log=TRUE))
    }, list( .lphi=lphi, .lmunb=lmunb, .lk=lk,
             .ephi=ephi, .emunb=emunb, .ek=ek ))),
    vfamily=c("zinegbinomial"),
    deriv=eval(substitute(expression({
        NOS = extra$NOS
        phi  = eta2theta(eta[,3*(1:NOS)-2,drop=FALSE], .lphi,  earg= .ephi )
        munb = eta2theta(eta[,3*(1:NOS)-1,drop=FALSE], .lmunb, earg= .emunb )
        kmat = eta2theta(eta[,3*(1:NOS),  drop=FALSE], .lk,    earg= .ek )
        dphi.deta = dtheta.deta(phi, .lphi, earg= .ephi )
        dmunb.deta = dtheta.deta(munb, .lmunb, earg= .emunb )
        dk.deta = dtheta.deta(kmat, .lk, earg= .ek )
        dthetas.detas = (cbind(dphi.deta, dmunb.deta,
                              dk.deta))[,interleave.VGAM(3*NOS, M=3)]

        d3 = deriv3(~ log(phi. + (1 - phi.) * (kmat. /(kmat. + munb. ))^kmat.),
                    c("phi.", "munb.", "kmat."), hessian=FALSE)
        dl.dthetas =  matrix(0, n, M)  # M=3*NOS; for all species
        for(spp. in 1:NOS) {
            index = (y[,spp.] == 0)
            if(!sum(index) || !sum(!index))
                stop("must have some 0s AND some positive counts in the data")

            yvec. = y[index,spp.]
            kmat. = kmat[index,spp.]
            munb. = munb[index,spp.]
            phi. = phi[index,spp.]
            eval.d3 = eval(d3)  # Evaluated for one species
            dl.dthetas[index,(3*spp.-2):(3*spp.)] = attr(eval.d3, "gradient")

            yvec. = y[!index,spp.]
            kmat. = kmat[!index,spp.]
            munb. = munb[!index,spp.]
            phi. = phi[!index,spp.]
            dl.dphi = -1/(1-phi.)
            dl.dmunb = yvec. / munb. - (yvec. +kmat.)/(kmat.+munb.)
            dl.dk = digamma(yvec. +kmat.) - digamma(kmat.) -
                    (yvec. +kmat.)/(munb.+kmat.) + 1 +
                    log(kmat./(kmat.+munb.))
            dl.dthetas[!index,(3*spp.-2):(3*spp.)] =
                cbind(dl.dphi, dl.dmunb, dl.dk)
        }
        w * dl.dthetas * dthetas.detas
    }), list( .lphi=lphi, .lmunb=lmunb, .lk=lk,
              .ephi=ephi, .emunb=emunb, .ek=ek ))),
    weight=eval(substitute(expression({

        wz = matrix(0, n, 3*(M-1))
        ind8 = iam(NA, NA, M=M, both=TRUE, diag=TRUE)
        ind1 = iam(NA, NA, M=3, both=TRUE, diag=TRUE)
        for(spp. in 1:NOS) {
            run.varcov = 0
            sdl.dthetas =  matrix(0, n, 3)
            for(ii in 1:( .nsimEIM )) {
                ysim = rzinegbin(n=n, phi=phi[,spp.],
                                 size=kmat[,spp.], mu=munb[,spp.])
                index = (ysim == 0)

                yvec. = ysim[index]
                kmat. = kmat[index,spp.]
                munb. = munb[index,spp.]
                phi. = phi[index,spp.]
                eval.d3 = eval(d3)  # Evaluated for one species
                sdl.dthetas[index,] = attr(eval.d3, "gradient")

                yvec. = ysim[!index]
                kmat. = kmat[!index,spp.]
                munb. = munb[!index,spp.]
                phi. = phi[!index,spp.]
                dl.dphi = -1/(1-phi.)
                dl.dmunb = yvec. / munb. - (yvec. +kmat.)/(kmat.+munb.)
                dl.dk = digamma(yvec. +kmat.) - digamma(kmat.) -
                        (yvec. +kmat.)/(munb.+kmat.) + 1 +
                        log(kmat./(kmat.+munb.))
                sdl.dthetas[!index,] = cbind(dl.dphi, dl.dmunb, dl.dk)
                temp3 = sdl.dthetas
                run.varcov = ((ii-1) * run.varcov +
                           temp3[,ind1$row.index]*temp3[,ind1$col.index]) / ii
            }
            wz1 = if(intercept.only)
                matrix(apply(run.varcov, 2, mean),
                       nr=n, nc=ncol(run.varcov), byrow=TRUE) else run.varcov

            wz1 = wz1 * dthetas.detas[,3*(spp. -1) + ind1$row] *
                        dthetas.detas[,3*(spp. -1) + ind1$col]

            for(jay in 1:3)
                for(kay in jay:3) {
                    cptr = iam((spp.-1)*3+jay, (spp.-1)*3+kay, M=M)
                    wz[,cptr] = wz1[,iam(jay, kay, M=3)]
                }
        }
        w * wz
    }), list( .lphi=lphi, .ephi=ephi, .nsimEIM=nsimEIM ))))
}




