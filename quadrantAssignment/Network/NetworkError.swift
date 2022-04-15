//
//  NetworkError.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation
import Moya

public enum NetworkError: Error {
    case unknown
    case notConnectedToInternet
    case internationalRoamingOff
    case notReachedServer
    case connectionLost
    case incorrectDataReturned
    case insecureConnection
    case cancelled
    case serviceUnavailable
    case emptyResponse
    case unAuthorized
    case gatewayTimeout
    case conflict
    case SoftError(message: String?)

    public var message: String {
        switch self {
        case .incorrectDataReturned:
            return "Incorrect JSON format"
        case .SoftError(let message):
          return message ?? "Something when wrong"
        case .notConnectedToInternet:
            return "You are offline"
        case .notReachedServer:
            return "Server not found"
        case .connectionLost:
            return "Connection lost"
        case .insecureConnection:
            return "Insecure connection"
        case .cancelled:
            return "Request Cancelled"
        case .serviceUnavailable:
            return "Service Unavailable"
        case .emptyResponse:
            return "Empty Response"
        case .gatewayTimeout:
            return "Gateway Timeout"
        default:
            return "Unknown error"
        }
    }

    internal init(error: NSError) {
        switch error.domain {
        case NSURLErrorDomain:
            switch error.code {
            case NSURLErrorCancelled:
                self = .cancelled
            case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost, NSURLErrorTimedOut, NSURLErrorDNSLookupFailed:
                self = .notReachedServer
            case NSURLErrorNetworkConnectionLost:
                self = .connectionLost
            case NSURLErrorNotConnectedToInternet:
                self = .notConnectedToInternet
            case NSURLErrorRedirectToNonExistentLocation, NSURLErrorBadServerResponse, NSURLErrorZeroByteResource, NSURLErrorCannotDecodeRawData, NSURLErrorCannotDecodeContentData,
                 NSURLErrorCannotParseResponse, NSURLErrorBadURL, NSURLErrorFileDoesNotExist, NSURLErrorFileIsDirectory, NSURLErrorResourceUnavailable,
                 NSURLErrorDataLengthExceedsMaximum, NSURLErrorUnsupportedURL:
                self = .incorrectDataReturned
            case NSURLErrorInternationalRoamingOff:
                self = .internationalRoamingOff
            default:
                self = .unknown
            }
        case String(kCFErrorDomainCFNetwork):
            switch error.code {
            case
            Int(CFNetworkErrors.cfurlErrorServerCertificateNotYetValid.rawValue),
            Int(CFNetworkErrors.cfurlErrorServerCertificateUntrusted.rawValue),
            Int(CFNetworkErrors.cfurlErrorServerCertificateHasBadDate.rawValue),
            Int(CFNetworkErrors.cfurlErrorServerCertificateHasUnknownRoot.rawValue),
            Int(CFNetworkErrors.cfurlErrorClientCertificateRejected.rawValue),
            Int(CFNetworkErrors.cfurlErrorClientCertificateRequired.rawValue),
            Int(CFNetworkErrors.cfErrorHTTPSProxyConnectionFailure.rawValue),
            Int(CFNetworkErrors.cfurlErrorSecureConnectionFailed.rawValue),
            Int(CFNetworkErrors.cfurlErrorCannotLoadFromNetwork.rawValue),
            Int(CFNetworkErrors.cfurlErrorCancelled.rawValue):
                self = .insecureConnection
            case Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue):
                self = .notConnectedToInternet
            default:
                self = .unknown
            }
        default:
            self = .unknown
        }
    }
}
