#' @title
#' Point estimates of HKEVP fit
#' 
#' @author Quentin Sebille
#' @description 
#' Application of a function to the main Markov chains resulting from the procedure \code{hkevp.fit}. May be used to obtain point estimates of the posterior distribution (e.g., the mean or the median). See details.
#' 
#' @param fit
#' A named list.
#' Output from the \code{hkevp.fit} procedure.
#' 
#' @param FUN
#' The function applied to the Markov chains in \code{fit}. The median by default. The output from FUN must be a single value.
#' 
#' @param ...
#' Optional arguments of the function to be applied on the Markov chains (e.g. \code{na.rm = FALSE}).
#'
#' 
#' 
#' @details 
#' A function is applied to the main Markov chains resulting from the MCMC procedures \code{hkevp.fit} or \code{latent.fit}. These chains correspond to the three GEV parameters, the dependence parameter \eqn{\alpha} and the bandwidth \eqn{\tau}.
#' 
#' The value returned by \code{FUN} must be a single value.
#'
#'
#' @return
#' If fitted model is the HKEVP, a named list with three elements:
#' \itemize{
#' \item \code{GEV}: A numerical matrix. Result of the function \code{FUN} for each GEV parameter (columns) and each site position (rows).
#' \item \code{alpha}: A numerical value. Result of the function \code{FUN} on the Markov chain associated to the dependence parameter \eqn{\alpha}.
#' \item \code{tau}: A numerical value. Result of the function \code{FUN} on the Markov chain associated to the bandwidth parameter \eqn{\tau}.
#' }
#' If fitted model is the latent variable model, the functions returns the \code{GEV} matrix only.
#' 
#' 
#' 
#' @examples
#' # Simulation of HKEVP:
#' \donttest{
#' sites <- as.matrix(expand.grid(1:3,1:3))
#' knots <- sites
#' loc <- sites[,1]*10
#' scale <- 3
#' shape <- .2
#' alpha <- .4
#' tau <- 1
#' ysim <- hkevp.rand(10, sites, knots, loc, scale, shape, alpha, tau)
#' 
#' # HKEVP fit:
#' fit <- hkevp.fit(ysim, sites, niter = 1000)
#' 
#' # Posterior median and standard deviation:
#' # mcmc.fun(fit, median)
#' # mcmc.fun(fit, sd)
#' }
#' 
#' 
mcmc.fun <- function(fit, FUN, ...) {
  # Default value of FUN
  if (missing(FUN)) FUN <- median
  
  # Applying FUN to each chain:
  if (fit$fit.type == "hkevp") {
    result <- list()
    result$GEV <- apply(fit$GEV, 1:2, FUN, ...)
    colnames(result$GEV) <- c('loc', 'scale', 'shape')
    result$alpha <- FUN(fit$alpha, ...)
    result$tau <- FUN(fit$tau, ...)
  }
  else if (fit$fit.type == "dep-only") {
    result <- list()
    result$alpha <- FUN(fit$alpha, ...)
    result$tau <- FUN(fit$tau, ...)
  }
  else if (fit$fit.type == "latent") {
    result <- list()
    result$GEV <- apply(fit$GEV, 1:2, FUN, ...)
    colnames(result$GEV) <- c('loc', 'scale', 'shape')
  }
  else stop("Incorrect fit.type!")
  
  return(result)
}
