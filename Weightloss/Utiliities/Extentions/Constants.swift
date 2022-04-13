//
//  Constants.swift
//  Weightloss
//
//  Created by benny mushiya on 28/04/2021.
//

import Foundation
import Firebase



let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_TEXTPOST = Firestore.firestore().collection("weightLossPosts")
let COLLECTION_WEIGHTGAIN = Firestore.firestore().collection("weightGainPosts")
let COLLECTION_PROGRESS = Firestore.firestore().collection("ProgressPosts")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_COMMENTS = Firestore.firestore().collection("comments")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")
let COLLECTION_QUOTES = Firestore.firestore().collection("Quotes")
let PUSH_NOTIFICATION_KEY = "AAAAugCljBc:APA91bHli-4XuyMt3VcEx9up9hH8wmOrUQz8WT9l4BI7-R1yyYJooBUAvsx354TMxAGFgj31KuiwoCSxPAI0xH-el6HbaN4296-L6a1mvAX8Wa8P0R-5_4gqqcpBM6RvY7P4rCoZoFud"



let FIRST_ONBOARDING_TITLE = "JOIN A COMMUNUNITY"

let FIRST_ONBOARDING_DESCRIPTION = " Join a community of like-minded individuals, to accomplish your fitness/physical goals to become a better version of yourself. "

let SECOND_ONBOARDING_TITLE = "INTERACT"

let SECOND_ONBOARDING_MESSAGE = " Share your thoughts and connect with your peers through a cross platform feed, that enables you to share your journey of progression "

let THIRD_ONBOARDING_TITLE = "BECOME A CORE MEMBER OF THE COMMUNITY"

let THIRD_ONBOARDING_MESSAGE = " Relate to other users posts that walked the same journey. and follow monthly challeneges to hasten your set goals "

