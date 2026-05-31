//
//  Article.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

struct Article: Identifiable {
    let id = UUID().uuidString
    let title: String
    let description: String
    let imageName: String
    
    static let stepsArticle = Article(
        title: "Movement and Your Mind",
        description: """
        ## A Gentle Start
        
        Walking is not only good for your body. It can also support your mental health in small, steady ways.
        
        Even a short walk can help your mind shift out of stress mode. Gentle movement increases blood flow, helps release tension, and gives your thoughts a little more space.
        
        ## Why Steps Matter
        
        Your step count is not a test or a score. It is simply one signal of how much your body moved today.
        
        Some days, a few thousand steps may feel easy. Other days, even a short walk can be enough. What matters most is noticing your energy with kindness.
        
        ## Movement and Mood
        
        Physical activity can support your mood by helping your body regulate stress hormones and release endorphins. It can also improve sleep, focus, and emotional balance over time.
        
        You do not need an intense workout to feel a difference. A calm walk outside, taking the stairs, stretching between tasks, or moving around your room can all count.
        
        ## A Gentle Check-In
        
        Look at your steps as an invitation, not pressure.
        
        Ask yourself:
        
        - Did I move in a way that supported me today?
        - Do I need rest, fresh air, or a short walk?
        - What kind of movement would feel kind right now?
        
        ## Small Practice
        
        Try taking a five-minute walk without multitasking. Notice your breathing, your pace, and the feeling of your feet touching the ground.
        
        Let movement become a way to return to yourself.
        """,
        imageName: "stepsArticle"
    )
    
    static let heartRateArticle = Article(
        title: "What Your Heart Rate Can Tell You",
        description: """
        ## A Quiet Signal
        
        Your heart rate is one of the body's quiet signals. It can reflect movement, stress, rest, emotions, caffeine, sleep, hydration, and many other parts of daily life.
        
        It is not a judgment of how well you are doing. It is simply information.
        
        ## Understanding Heart Rate
        
        Heart rate is usually measured in beats per minute, or BPM. A higher number can happen during exercise, stress, excitement, or after drinking caffeine. A lower number can appear during rest, sleep, or calm moments.
        
        Your normal heart rate can be different from someone else's. Patterns over time are often more useful than one single number.
        
        ## Stress and the Body
        
        When you feel anxious or overwhelmed, your nervous system may become more activated. Your heart may beat faster as your body prepares to respond.
        
        This does not always mean something is wrong. Sometimes it means your body is trying to protect you.
        
        ## A Moment to Pause
        
        If your heart rate feels higher than usual, you can use it as a gentle reminder to check in.
        
        Ask yourself:
        
        - Did I sleep enough?
        - Have I eaten or had water?
        - Am I stressed, rushed, or tense?
        - Would a slow breath help right now?
        
        ## Small Practice
        
        Try this for one minute:
        
        - Inhale slowly through your nose.
        - Exhale a little longer than you inhale.
        - Relax your shoulders.
        - Notice if your body softens, even slightly.
        
        ## Listen With Kindness
        
        Your heart rate is not something to fear or control perfectly. It is one part of the conversation between your body and your mind.
        
        Use it as a soft signal to care for yourself.
        """,
        imageName: "heartRateArticle"
    )
}
