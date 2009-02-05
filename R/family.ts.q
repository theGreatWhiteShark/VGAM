# These functions are
# Copyright (C) 1998-2009 T.W. Yee, University of Auckland. All rights reserved.





        rrar.Ci <- function(i, coeffs, aa, Ranks., MM) {
            index <- cumsum(c(aa, MM*Ranks.))
            ans<-matrix(coeffs[(index[i]+1):index[i+1]], Ranks.[i], MM, byrow=TRUE)
            t(ans)
        }
        rrar.Ak1 <- function(MM, coeffs, Ranks., aa) {
            ptr <- 0
            Ak1 <- diag(MM)
            for(j in 1:MM) {
                for(i in 1:MM) {
                    if(i>j && (MM+1)-(Ranks.[j]-1) <= i) {
                        ptr <- ptr + 1
                        Ak1[i,j] <- coeffs[ptr]
                    }
                }
            }
            if(aa>0 && ptr != aa) stop("something wrong")
            Ak1
        }
        rrar.Di <- function(i, Ranks.) {
            if(Ranks.[1]==Ranks.[i]) diag(Ranks.[i]) else 
            rbind(diag(Ranks.[i]), matrix(0, Ranks.[1]-Ranks.[i], Ranks.[i]))
        }
        rrar.Mi <- function(i, MM, Ranks., ki) {
            if(Ranks.[ki[i]]==MM)
                return(NULL)
            hi <- Ranks.[ki[i]] - Ranks.[ki[i+1]]
            Ji <- matrix(0, hi, Ranks.[1])
            for(j in 1:hi) {
                Ji[j,j+Ranks.[ki[i+1]]] <- 1
            }
            Mi <- matrix(0, MM-Ranks.[ki[i]], MM)  # dim(Oi) == dim(Ji)
            for(j in 1:(MM-Ranks.[ki[i]])) {
                Mi[j,j+Ranks.[ki[i  ]]] <- 1
            }
            kronecker(Mi, Ji)
        }
        rrar.Mmat <- function(MM, uu, Ranks., ki) {
            Mmat <- NULL
            for(i in uu:1) {
                Mmat <- rbind(Mmat, rrar.Mi(i, MM, Ranks., ki))
            }
            Mmat
        }
        block.diag <- function(A, B) {
            if(is.null(A) && is.null(B))
                return(NULL)
            if(!is.null(A) && is.null(B))
                return(A)
            if(is.null(A) && !is.null(B))
                return(B)

            A <- as.matrix(A)
            B <- as.matrix(B)
            temp <- cbind(A, matrix(0, nrow(A), ncol(B)))
            rbind(temp, cbind(matrix(0, nrow(B), ncol(A)), B))
        }
        rrar.Ht <- function(plag, MM, Ranks., coeffs, aa, uu, ki) {
            Htop <- Hbot <- NULL
            Mmat <- rrar.Mmat(MM, uu, Ranks., ki)   # NULL if full rank
            Ak1 <- rrar.Ak1(MM, coeffs, Ranks., aa)

            if(!is.null(Mmat))
            for(i in 1:plag) {
                Di <- rrar.Di(i, Ranks.)
                Ci <- rrar.Ci(i, coeffs, aa, Ranks., MM)
                temp <- Di %*% t(Ci)
                Htop <- cbind(Htop, Mmat %*% kronecker(diag(MM), temp))
            }

            for(i in 1:plag) {
                Di <- rrar.Di(i, Ranks.)
                temp <- kronecker(t(Di) %*% t(Ak1), diag(MM))
                Hbot <- block.diag(Hbot, temp)
            }
            rbind(Htop, Hbot)
        }
        rrar.Ut <- function(y, tt, plag, MM) {
            Ut <- NULL
            if(plag>1)
            for(i in 1:plag) {
                Ut <- rbind(Ut, kronecker(diag(MM), cbind(y[tt-i,])))
            }
            Ut
        }
        rrar.UU <- function(y, plag, MM, n) {
            UU <- NULL
            for(i in (plag+1):n) {
                UU <- rbind(UU, t(rrar.Ut(y, i, plag, MM)))
            }
            UU
        }
        rrar.Wmat <- function(y, Ranks., MM, ki, plag, aa, uu, n, coeffs) {
            temp1 <- rrar.UU(y, plag, MM, n)
            temp2 <- t(rrar.Ht(plag, MM, Ranks., coeffs, aa, uu, ki))
            list(UU=temp1, Ht=temp2)
        }



rrar.control <- function(stepsize=0.5, save.weight=TRUE, ...)
{

    if(stepsize <= 0 || stepsize > 1) {
        warning("bad value of stepsize; using 0.5 instead")
        stepsize <- 0.5
    }
    list(stepsize=stepsize, save.weight = as.logical(save.weight)[1])
}


rrar <- function(Ranks=1, coefstart=NULL)
{
    lag.p <- length(Ranks)
    new("vglmff",
    blurb=c("Nested reduced-rank vector autoregressive model AR(", lag.p,
           ")\n\n",
           "Link:     ",
           namesof("mu_t", "identity"),
           ", t = ", paste(paste(1:lag.p, coll=",", sep="")) ,
           ""),
    initialize=eval(substitute(expression({
        Ranks. <- .Ranks
        plag <- length(Ranks.)
        nn <- nrow(x)   # original n
        pp <- ncol(x)
        indices <- 1:plag

        copyxbig <- TRUE   # xbig.save matrix changes at each iteration 

        dsrank <- -sort(-Ranks.)   # ==rev(sort(Ranks.))
        if(any(dsrank != Ranks.))
            stop("Ranks must be a non-increasing sequence")
        if(!is.matrix(y) || ncol(y) ==1) {
            stop("response must be a matrix with more than one column")
        } else {
            MM <- ncol(y)
            ki <- udsrank <- unique(dsrank)
            uu <- length(udsrank)
            for(i in 1:uu)
               ki[i] <- max((1:plag)[dsrank==udsrank[i]])
            ki <- c(ki, plag+1)  # For computing a
            Ranks. <- c(Ranks., 0) # For computing a
            aa <- sum( (MM-Ranks.[ki[1:uu]]) * (Ranks.[ki[1:uu]]-Ranks.[ki[-1]]) )
        }
        if(!intercept.only)
            warning("ignoring explanatory variables")

        if(any(MM < Ranks.))
            stop(paste("max(Ranks) can only be", MM, "or less"))
        y.save <- y  # Save the original
        if(any(w != 1))
            stop("all weights should be 1")

        new.coeffs <- .coefstart  # Needed for iter=1 of $weight
        new.coeffs <- if(length(new.coeffs))
                          rep(new.coeffs, len=aa+sum(Ranks.)*MM) else
                          runif(aa+sum(Ranks.)*MM)
        temp8 <- rrar.Wmat(y.save,Ranks.,MM,ki,plag,aa,uu,nn,new.coeffs)
        xbig.save <- temp8$UU %*% temp8$Ht 

        if(!length(etastart)) {
            etastart <- xbig.save %*% new.coeffs
            etastart <- matrix(etastart, ncol=ncol(y), byrow=TRUE) # So M=ncol(y)
        }

        extra$Ranks. <- Ranks.; extra$aa <- aa
        extra$plag <- plag; extra$nn <- nn
        extra$MM <- MM; extra$coeffs <- new.coeffs;
        extra$y.save <- y.save

        keep.assign <- attr(x, "assign")
        x <- x[-indices,,drop=FALSE]
        if(is.R())
            attr(x, "assign") <- keep.assign
        y <- y[-indices,,drop=FALSE]
        w <- w[-indices]
        n.save <- n <- nn - plag
    }), list( .Ranks=Ranks, .coefstart=coefstart ))), 
    inverse=function(eta, extra=NULL) {
        aa <- extra$aa
        coeffs <- extra$coeffs
        MM <- extra$MM
        nn <- extra$nn
        plag <- extra$plag
        Ranks. <- extra$Ranks.
        y.save <- extra$y.save

        tt <- (1+plag):nn
        mu <- matrix(0, nn-plag, MM)
        Ak1 <- rrar.Ak1(MM, coeffs, Ranks., aa)
        for(i in 1:plag) {
            Di <- rrar.Di(i, Ranks.)
            Ci <- rrar.Ci(i, coeffs, aa, Ranks., MM)
            mu <- mu + y.save[tt-i,,drop=FALSE] %*% t(Ak1 %*% Di %*% t(Ci))
        }
        mu
    },
    last=expression({
        misc$plag <- plag
        misc$Ranks <- Ranks.
        misc$Ak1 <- Ak1
        misc$omegahat <- omegahat
        misc$Cmatrices <- Cmatrices
        misc$Dmatrices <- Dmatrices
        misc$Hmatrix <- temp8$Ht
        misc$Phimatrices <- vector("list", plag)
        for(i in 1:plag) {
            misc$Phimatrices[[i]] = Ak1 %*% Dmatrices[[i]] %*% t(Cmatrices[[i]])
        }
        misc$Z <- y.save %*% t(solve(Ak1)) 
    }),
    vfamily="rrar",
    deriv=expression({
        temp8 <- rrar.Wmat(y.save,Ranks.,MM,ki,plag,aa,uu,nn,new.coeffs)
        xbig.save <- temp8$UU %*% temp8$Ht 

        extra$coeffs <- new.coeffs

        resmat <- y
        tt <- (1+plag):nn
        Ak1 <- rrar.Ak1(MM, new.coeffs, Ranks., aa)
        Cmatrices <- Dmatrices <- vector("list", plag)
        for(i in 1:plag) {
            Dmatrices[[i]] <- Di <- rrar.Di(i, Ranks.)
            Cmatrices[[i]] <- Ci <- rrar.Ci(i, new.coeffs, aa, Ranks., MM)
            resmat <- resmat - y.save[tt-i,,drop=FALSE] %*% t(Ak1 %*% Di %*% t(Ci))
            NULL
        }
        omegahat <- (t(resmat) %*% resmat) / n  # MM x MM
        omegainv <- solve(omegahat)

        omegainv <- solve(omegahat)
        ind1 <- iam(NA,NA,MM,both=TRUE)

        wz = matrix(omegainv[cbind(ind1$row,ind1$col)],
                    nn-plag, length(ind1$row), byrow=TRUE)
        mux22(t(wz), y-mu, M=extra$MM, as.mat=TRUE)
    }),
    weight=expression({
        wz
    }))
}




vglm.garma.control <- function(save.weight=TRUE, ...)
{
    list(save.weight = as.logical(save.weight)[1])
}


garma <- function(link=c("identity","loge","reciprocal",
                        "logit","probit","cloglog","cauchit"),
                  earg=list(),
                  p.ar.lag=1, q.lag.ma=0,
                  coefstart=NULL,
                  step=1.0)
{
    if(mode(link) != "character" && mode(link) != "name")
        link = as.character(substitute(link))
    link = match.arg(link, c("identity","loge","reciprocal",
                             "logit","probit","cloglog","cauchit"))[1]
    if(!is.Numeric(p.ar.lag, integer=TRUE))
        stop("bad input for argument \"p.ar.lag\"")
    if(!is.Numeric(q.lag.ma, integer=TRUE))
        stop("bad input for argument \"q.lag.ma\"")
    if(q.lag.ma != 0)
        stop("sorry, only q.lag.ma=0 is currently implemented")
    if(!is.list(earg)) earg = list()

    new("vglmff",
    blurb=c("GARMA(", p.ar.lag, ",", q.lag.ma, ")\n\n",
           "Link:     ",
           namesof("mu_t", link, earg= earg),
           ", t = ", paste(paste(1:p.ar.lag, coll=",", sep=""))),
    initialize=eval(substitute(expression({
        plag <- .p.ar.lag
        predictors.names = namesof("mu", .link, earg= .earg, tag=FALSE)
        indices <- 1:plag
        tt <- (1+plag):nrow(x) 
        pp <- ncol(x)

        copyxbig <- TRUE   # x matrix changes at each iteration 

        if( .link == "logit" || .link == "probit" || .link == "cloglog" ||
            .link == "cauchit") {
            delete.zero.colns <- TRUE
            eval(process.categorical.data.vgam)
            mustart <- mustart[tt,2]
            y <- y[,2]
        }

        x.save <- x  # Save the original
        y.save <- y  # Save the original
        w.save <- w  # Save the original

        new.coeffs <- .coefstart  # Needed for iter=1 of @weight
        new.coeffs <- if(length(new.coeffs)) rep(new.coeffs, len=pp+plag) else 
                      c(runif(pp), rep(0, plag)) 
        if(!length(etastart)) {
            etastart <- x[-indices,,drop=FALSE] %*% new.coeffs[1:pp]
        }
        x <- cbind(x, matrix(as.numeric(NA), n, plag)) # Right size now 
        dx <- dimnames(x.save)
        morenames <- paste("(lag", 1:plag, ")", sep="") 
        dimnames(x) <- list(dx[[1]], c(dx[[2]], morenames)) 

        x <- x[-indices,,drop=FALSE]
        class(x) = if(is.R()) "matrix" else "model.matrix"  # Added 27/2/02; 26/2/04
        y <- y[-indices]
        w <- w[-indices]
        n.save <- n <- n - plag
        more <- vector("list", plag)
        names(more) <- morenames
        for(i in 1:plag)
            more[[i]] <- i + max(unlist(attr(x.save, "assign")))
        attr(x, "assign") <- c(attr(x.save, "assign"), more)
    }), list( .link=link, .p.ar.lag=p.ar.lag, .coefstart=coefstart, .earg=earg ))), 
    inverse=eval(substitute(function(eta, extra=NULL) {
        eta2theta(eta, link= .link, earg= .earg)
    }, list( .link=link, .earg=earg ))),
    last=eval(substitute(expression({
        misc$link <- c(mu = .link)
        misc$earg <- list(mu = .earg)
        misc$plag <- plag
    }), list( .link=link, .earg=earg ))),
    loglikelihood=eval(substitute(
        function(mu, y, w, residuals = FALSE, eta, extra=NULL) {
        if(residuals) switch( .link,
            identity=y-mu,
            loge=w*(y/mu - 1),
            inverse=w*(y/mu - 1),
            w*(y/mu - (1-y)/(1-mu))) else
        switch( .link,
            identity=sum(w*(y-mu)^2),
            loge=sum(w*(-mu + y*log(mu))),
            inverse=sum(w*(-mu + y*log(mu))),
            sum(w*(y*log(mu) + (1-y)*log1p(-mu))))
    }, list( .link=link, .earg=earg ))),
    middle2=eval(substitute(expression({
        realfv <- fv
        for(i in 1:plag) {
            realfv <- realfv + old.coeffs[i+pp] *
                  (x.save[tt-i,1:pp,drop=FALSE] %*% new.coeffs[1:pp]) # + 
        }

        true.eta <- realfv + offset  
        mu <- family@inverse(true.eta, extra)  # overwrite mu with correct one
    }), list( .link=link, .earg=earg ))),
    vfamily=c("garma", "vglmgam"),
    deriv=eval(substitute(expression({
        dl.dmu <- switch( .link,
                      identity=y-mu,
                      loge=(y-mu)/mu,
                      inverse=(y-mu)/mu,
                      (y-mu) / (mu*(1-mu)))
        dmu.deta <- dtheta.deta(mu, .link, earg= .earg)
        step <- .step      # This is another method of adjusting step lengths
        step * w * dl.dmu * dmu.deta
    }), list( .link=link, .step=step, .earg=earg ))),
    weight=eval(substitute(expression({
        x[,1:pp] <- x.save[tt,1:pp] # Reinstate 

        for(i in 1:plag) {
            temp = theta2eta(y.save[tt-i], .link, earg= .earg)
            x[,1:pp] <- x[,1:pp] - x.save[tt-i,1:pp] * new.coeffs[i+pp] 
            x[,pp+i] <- temp - x.save[tt-i,1:pp,drop=FALSE] %*% new.coeffs[1:pp]
        }
        class(x)=if(is.R()) "matrix" else "model.matrix" # Added 27/2/02; 26/2/04

        if(iter==1)
            old.coeffs <- new.coeffs 

        xbig.save <- lm2vlm.model.matrix(x, Blist, xij=control$xij)

        vary = switch( .link,
                       identity=1,
                       loge=mu,
                       inverse=mu^2,
                       mu*(1-mu))
        w * dtheta.deta(mu, link= .link, earg= .earg)^2 / vary
    }), list( .link=link,
              .earg=earg ))))
}






if(FALSE) {
setClass(Class="Coef.rrar", representation(
         "plag"    = "integer",
         "Ranks"   = "integer",
         "omega"   = "integer",
         "C"       = "matrix",
         "D"       = "matrix",
         "H"       = "matrix",
         "Z"       = "matrix",
         "Phi"     = "list",  # list of matrices
         "Ak1"     = "matrix"))



Coef.rrar = function(object, ...) {
    result = new(Class="Coef.rrar",
         "plag"     = object@misc$plag,
         "Ranks"    = object@misc$Ranks,
         "omega"    = object@misc$omega,
         "C"        = object@misc$C,
         "D"        = object@misc$D,
         "H"        = object@misc$H,
         "Z"        = object@misc$Z,
         "Phi"      = object@misc$Phi,
         "Ak1"      = object@misc$Ak1)
}

print.Coef.rrar = function(x, ...) {
    cat(x@plag)
}


setMethod("Coef", "rrar",
         function(object, ...)
         Coef(object, ...))

setMethod("print", "Coef.rrar",
         function(x, ...)
         invisible(print.Coef.rrar(x, ...)))
}


