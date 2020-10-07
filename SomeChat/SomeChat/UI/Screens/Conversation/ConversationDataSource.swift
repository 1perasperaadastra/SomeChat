//
//  ConversationDataSource.swift
//  SomeChat
//
//  Created by Алексей Махутин on 29.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

internal final class ConversationDataSource {

    func loadMessage() -> [ConversationMessageModel] {
        let text = """
        Had strictly mrs handsome mistaken cheerful. We it so if resolution invitation
        remarkably unpleasant conviction. As into ye then form. To easy five less if rose
        were. Now set offended own out required entirely. Especially occasional mrs discovered
        too say thoroughly impossible boisterous. My head when real no he high rich at with. After so p
        ower of young as. Bore year does has get long fat cold saw neat. Put boy carried chiefly shy general.

        Cause dried no solid no an small so still widen. Ten weather evident smiling bed against she examine
        its. Rendered far opinions two yet moderate sex striking. Sufficient motionless compliment by stimulated
        assistance at. Convinced resolving extensive agreeable in it on as remainder. Cordially say affection met
        who propriety him. Are man she towards private weather pleased. In more part he lose need so want rank no.
        At bringing or he sensible pleasure. Prevent he parlors do waiting be females an message society.

        Situation admitting promotion at or to perceived be. Mr acuteness we as estimable enjoyment up. An held
        late as felt know. Learn do allow solid to grave. Middleton suspicion age her attention. Chiefly several
        bed its wishing. Is so moments on chamber pressed to. Doubtful yet way properly answered humanity its desirous.
        Minuter believe service arrived civilly add all. Acuteness allowance an at eagerness favourite
        in extensive exquisite ye.

        Sociable on as carriage my position weddings raillery consider. Peculiar trifling absolute and wandered
        vicinity property yet. The and collecting motionless difficulty son. His hearing staying ten colonel met. Sex
        drew six easy four dear cold deny. Moderate children at of outweigh it. Unsatiable it considered invitation he
        travelling insensible. Consulted admitting oh mr up as described acuteness propriety moonlight.

        Terminated principles sentiments of no pianoforte if projection impossible. Horses pulled nature favour number
        yet highly his has old. Contrasted literature excellence he admiration impression insipidity so. Scale ought who
        terms after own quick since. Servants margaret husbands to screened in throwing. Imprudence oh an
        collecting partiality. Admiration gay difficulty unaffected how.
        """
        var result = [ConversationMessageModel]()
        let maxDistance = 40
        for _ in 0..<40 {
            let initalIndex = Int.random(in: 0..<text.count)
            let endIndex = Int.random(in: initalIndex..<min(initalIndex + maxDistance, text.count))
            let start = text.index(text.startIndex, offsetBy: initalIndex)
            let end = text.index(text.startIndex, offsetBy: endIndex)
            let message = String(text[start..<end])
            result.append(ConversationMessageModel(type: self.randomDirection(),
                                                   cellModel: MessageCellModel(text: message)))
        }
        return result
    }

    private func randomDirection() -> ConversationMessageModel.Direction {
        let magic = Bool.random()
        return magic ? .incoming : .outgoing
    }
}
