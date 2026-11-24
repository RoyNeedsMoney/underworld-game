import SwiftUI

struct ContentView: View {
    @State private var screen: AppScreen = .start
    @State private var respect = 10
    @State private var money = 5
    @State private var currentStep = 1
    @State private var eventMessage = ""
    @State private var isShowingResult = false
    @State private var ending: Ending = .bottom

    var body: some View {
        ZStack {
            NoirPalette.background
                .ignoresSafeArea()

            switch screen {
            case .start:
                StartView {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.86)) {
                        screen = .game
                    }
                }
            case .game:
                GameView(
                    respect: respect,
                    money: money,
                    currentStep: currentStep,
                    eventMessage: eventMessage,
                    isShowingResult: isShowingResult,
                    choose: applyChoice,
                    continueJourney: continueJourney
                )
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            case .ending:
                EndingView(
                    ending: ending,
                    respect: respect,
                    money: money,
                    restart: restart
                )
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }
        }
    }

    private func applyChoice(_ choiceIndex: Int) {
        guard !isShowingResult else { return }

        if currentStep == 1 {
            if choiceIndex == 0 {
                respect += 15
                money += 5
                eventMessage = "碎裂的招牌讓整條街安靜下來。你的名字，第一次被人低聲提起。"
            } else {
                respect += 10
                money -= 5
                eventMessage = "攤販感激地低頭。你花的是錢，收的是未來的人心。"
            }
        } else if currentStep == 2 {
            if choiceIndex == 0 {
                respect += 20
                eventMessage = "血色規矩立在賭桌旁。從今以後，沒人敢在你的場子出千。"
            } else {
                money += 25
                respect -= 5
                eventMessage = "封口費落袋。江湖知道你精明，但也開始懷疑你的底線。"
            }
        } else if currentStep == 3 {
            if choiceIndex == 0 {
                if money >= 15 {
                    money -= 15
                    respect += 15
                    eventMessage = "隊長收下鈔票，貨車穿過封鎖線。你用錢買到了一次通行。"
                } else {
                    respect -= 10
                    eventMessage = "資金不足，隊長冷笑著收隊。這次失手讓堂口對你失望。"
                }
            } else {
                respect += 25
                eventMessage = "鐵門關上的聲音很重，但兄弟們記住了：你肯替大家扛。"
            }
        } else if currentStep == 4 {
            if choiceIndex == 0 {
                respect += 25
                money += 10
                eventMessage = "蘇菲亞的情報網向你敞開。金錢與權力的耳語，都將先傳到你耳邊。"
            } else if choiceIndex == 1 {
                money += 35
                respect += 10
                eventMessage = "安娜替你打開家族金庫。資本開始替你鋪路，元老也另眼相看。"
            } else {
                respect += 15
                eventMessage = "你推開酒杯，把目光放回權力地圖。野心比任何香水都更濃烈。"
            }
        } else if currentStep == 5 {
            if choiceIndex == 0 {
                respect += 25
                money -= 10
                eventMessage = "槍火照亮街口。你守住地盤，也讓兄弟見識到誰敢站在最前面。"
            } else {
                respect += 15
                money += 15
                eventMessage = "敵人自相殘殺，你坐收漁利。這一局，腦子比拳頭更值錢。"
            }
        } else if currentStep == 6 {
            if choiceIndex == 0 {
                respect += 30
                eventMessage = "你掃清病房外的野心家。老大醒來時，整個堂口只剩一個聲音。"
            } else {
                money += 35
                respect -= 10
                eventMessage = "二當家的產業歸你，但人們開始在背後衡量你的忠誠。"
            }
        } else if currentStep == 7 {
            if choiceIndex == 0 {
                if money >= 40 {
                    money += 50
                    respect += 25
                    eventMessage = "整批貨成功出海。你不只賺到巨款，更一躍成為各方忌憚的堂主。"
                } else {
                    money -= 15
                    eventMessage = "資金不足，交易對象當場翻臉。訂金與面子一起被你留在碼頭。"
                }
            } else {
                money += 20
                respect += 10
                eventMessage = "你選擇穩健抽成。風險不在你身上，財富卻持續流進你的帳戶。"
            }
        } else if currentStep == 8 {
            if choiceIndex == 0 {
                respect += 20
                eventMessage = "你踏入會議廳，沉默比宣言更有力量。所有元老都感受到你的壓迫感。"
            } else {
                money += 20
                respect += 10
                eventMessage = "籌碼一一送到元老手上。今晚的王座，開始向最會算帳的人傾斜。"
            }
        }

        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
            isShowingResult = true
        }
    }

    private func continueJourney() {
        withAnimation(.easeInOut(duration: 0.35)) {
            if currentStep < 8 {
                currentStep += 1
                isShowingResult = false
                eventMessage = ""
            } else {
                determineEnding()
                screen = .ending
            }
        }
    }

    private func determineEnding() {
        if respect >= 80 && money >= 80 {
            ending = .godfather
        } else if money >= 80 && respect < 80 {
            ending = .tycoon
        } else if respect >= 80 && money < 50 {
            ending = .streetLegend
        } else {
            ending = .bottom
        }
    }

    private func restart() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.86)) {
            respect = 10
            money = 5
            currentStep = 1
            eventMessage = ""
            isShowingResult = false
            ending = .bottom
            screen = .start
        }
    }
}

private enum AppScreen {
    case start
    case game
    case ending
}

private enum Ending {
    case godfather
    case tycoon
    case streetLegend
    case bottom

    var title: String {
        switch self {
        case .godfather: "頂級黑幫教父"
        case .tycoon: "幕後隱形富豪"
        case .streetLegend: "悲劇街頭悍將"
        case .bottom: "永遠的底層小弟"
        }
    }

    var subtitle: String {
        switch self {
        case .godfather: "黑金王座已為你加冕。從此以後，規矩由你寫下。"
        case .tycoon: "你藏在聚光燈外，讓財富替你操控整座城市。"
        case .streetLegend: "你贏得了敬畏，卻沒能躲過街頭最冷的一顆子彈。"
        case .bottom: "棋局落幕，你不是被遺忘，就是在鐵窗後重來。"
        }
    }

    var symbol: String {
        switch self {
        case .godfather: "crown.fill"
        case .tycoon: "building.columns.fill"
        case .streetLegend: "flame.fill"
        case .bottom: "lock.fill"
        }
    }
}

private struct GameChapter: Identifiable {
    let id: Int
    let title: String
    let description: String
    let symbol: String
    let choices: [String]

    static let all: [GameChapter] = [
        GameChapter(
            id: 1,
            title: "街頭收保護費",
            description: "剛入幫的第一個任務，老實攤販繳不出錢。你要讓街頭記住你的拳頭，還是記住你的手腕？",
            symbol: "storefront.fill",
            choices: ["狠心砸攤立威", "自掏腰包幫他墊付收買人心"]
        ),
        GameChapter(
            id: 2,
            title: "地下賭場風波",
            description: "堂口賭場有人出老千。眾目睽睽下，你必須決定這張賭桌的規矩。",
            symbol: "suit.spade.fill",
            choices: ["當場抓出來砍手指立規矩", "私下勒索他一筆封口費"]
        ),
        GameChapter(
            id: 3,
            title: "警局臨檢危機",
            description: "幫派走私貨車被條子攔下。隊長的手伸在半空中，等待你的答案。",
            symbol: "car.rear.and.collision.road.lane",
            choices: ["花錢買通隊長放行（需資金 15）", "自己扛下罪名坐幾個月牢"]
        ),
        GameChapter(
            id: 4,
            title: "夜總會的紅牌抉擇",
            description: "慶功宴上，掌控政商情報的冷豔歌姬．蘇菲亞，與家族金庫千金．安娜，同時向你敬酒。",
            symbol: "sparkles",
            choices: ["選擇蘇菲亞，建立情報網", "選擇安娜，取得資金贊助", "不近女色、專心拼事業"]
        ),
        GameChapter(
            id: 5,
            title: "地盤爭奪火拼",
            description: "敵對幫派越界搶地盤。今晚的街口，只能有一個人說了算。",
            symbol: "scope",
            choices: ["帶兄弟正面硬剛", "設局挑撥離間讓他們內鬥"]
        ),
        GameChapter(
            id: 6,
            title: "老大遇襲重傷",
            description: "幫派老大遭暗算住院，二當家想趁機奪權。忠誠與野心，在此刻只能選一邊。",
            symbol: "cross.case.fill",
            choices: ["忠心護主、清理門戶", "趁火打劫、吞併二當家產業"]
        ),
        GameChapter(
            id: 7,
            title: "跨國軍火與洗錢生意",
            description: "你終於坐上堂主位置，面對黑道最大筆的交易。這是翻身一搏，或穩健進帳？",
            symbol: "ship.fill",
            choices: ["全押資金吃下整批貨（需資金 40）", "穩健抽成當中間人"]
        ),
        GameChapter(
            id: 8,
            title: "最終決戰：教父加冕之夜",
            description: "幫派元老大會召開，下一任龍頭的寶座近在眼前。你將如何拿下全場？",
            symbol: "crown.fill",
            choices: ["霸氣展示實力震懾全場", "大撒金錢收買所有元老"]
        )
    ]
}

private struct StartView: View {
    let start: () -> Void

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image("cover")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()

                LinearGradient(
                    colors: [.black.opacity(0.18), NoirPalette.background.opacity(0.74), NoirPalette.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 18) {
                    Spacer()

                    Text("黑道風雲")
                        .font(.system(.largeTitle, design: .serif, weight: .black))
                        .foregroundStyle(NoirPalette.gold)
                        .shadow(color: .black, radius: 8, y: 3)

                    Text("從底層到教父")
                        .font(.title3.weight(.semibold))
                        .tracking(5)
                        .foregroundStyle(.white.opacity(0.84))

                    Text("八個抉擇，決定你能否坐上黑金王座。")
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button(action: start) {
                        Label("踏入黑道", systemImage: "arrow.right.circle.fill")
                    }
                    .buttonStyle(GoldButtonStyle())
                    .padding(.top, 18)

                    Spacer()
                        .frame(height: 44)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct GameView: View {
    let respect: Int
    let money: Int
    let currentStep: Int
    let eventMessage: String
    let isShowingResult: Bool
    let choose: (Int) -> Void
    let continueJourney: () -> Void

    private var chapter: GameChapter {
        GameChapter.all[currentStep - 1]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                GameHeader(step: currentStep, respect: respect, money: money)

                ChapterCard(chapter: chapter)

                if isShowingResult {
                    EventResultCard(message: eventMessage, isFinalStep: currentStep == 8, action: continueJourney)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    ChoiceList(choices: chapter.choices, choose: choose)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
        .scrollIndicators(.hidden)
    }
}

private struct GameHeader: View {
    let step: Int
    let respect: Int
    let money: Int

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("第 \(step) / 8 關")
                    .font(.headline)
                    .foregroundStyle(NoirPalette.gold)

                Spacer()

                Text("黑金生涯")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.64))
            }

            ProgressView(value: Double(step), total: 8)
                .tint(NoirPalette.gold)
                .scaleEffect(y: 1.5)

            HStack(spacing: 12) {
                StatBadge(title: "威望", value: respect, symbol: "person.3.fill", color: NoirPalette.red)
                StatBadge(title: "資金", value: money, symbol: "banknote.fill", color: NoirPalette.gold)
            }
        }
    }
}

private struct StatBadge: View {
    let title: String
    let value: Int
    let symbol: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .foregroundStyle(color)
            Text(title)
                .foregroundStyle(.white.opacity(0.72))
            Text("\(value) 萬")
                .fontWeight(.heavy)
                .foregroundStyle(.white)
        }
        .font(.subheadline)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.07), in: Capsule())
        .overlay(Capsule().stroke(color.opacity(0.6), lineWidth: 1))
    }
}

private struct ChapterCard: View {
    let chapter: GameChapter

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ChapterVisual(step: chapter.id, symbol: chapter.symbol)

            VStack(alignment: .leading, spacing: 8) {
                Text(chapter.id == 4 ? "★ 特殊美女關卡" : "黑道抉擇")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(NoirPalette.gold)

                Text(chapter.title)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)

                Text(chapter.description)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(NoirPalette.card, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(NoirPalette.gold.opacity(0.76), lineWidth: 1.2))
        .shadow(color: .black.opacity(0.38), radius: 14, y: 8)
    }
}

private struct ChapterVisual: View {
    let step: Int
    let symbol: String

    var body: some View {
        Group {
            if step == 4 {
                Image("beauties")
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    LinearGradient(
                        colors: [NoirPalette.gold.opacity(0.3), .black.opacity(0.94), NoirPalette.red.opacity(0.32)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Image(systemName: symbol)
                        .font(.system(size: 54, weight: .bold))
                        .foregroundStyle(NoirPalette.gold)
                        .shadow(color: .black, radius: 8)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.16), lineWidth: 1))
    }
}

private struct ChoiceList: View {
    let choices: [String]
    let choose: (Int) -> Void

    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                Button {
                    choose(index)
                } label: {
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.headline.weight(.black))
                            .foregroundStyle(NoirPalette.background)
                            .frame(width: 30, height: 30)
                            .background(NoirPalette.gold, in: Circle())

                        Text(choice)
                            .font(.body.weight(.semibold))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)

                        Spacer(minLength: 0)

                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(NoirPalette.gold)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(ChoiceButtonStyle())
            }
        }
    }
}

private struct EventResultCard: View {
    let message: String
    let isFinalStep: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bolt.fill")
                .font(.title)
                .foregroundStyle(NoirPalette.gold)

            Text("局勢已定")
                .font(.headline.weight(.bold))
                .foregroundStyle(NoirPalette.gold)

            Text(message)
                .font(.body)
                .foregroundStyle(.white.opacity(0.86))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: action) {
                Label(isFinalStep ? "揭曉命運" : "繼續前進", systemImage: isFinalStep ? "crown.fill" : "arrow.right")
            }
            .buttonStyle(GoldButtonStyle())
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(NoirPalette.card, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(NoirPalette.gold, lineWidth: 1.2))
    }
}

private struct EndingView: View {
    let ending: Ending
    let respect: Int
    let money: Int
    let restart: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 26)

                EndingVisual(ending: ending)

                Text("你的結局")
                    .font(.headline)
                    .foregroundStyle(NoirPalette.gold)

                Text(ending.title)
                    .font(.system(.largeTitle, design: .serif, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text(ending.subtitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.78))
                    .padding(.horizontal, 28)

                HStack(spacing: 12) {
                    StatBadge(title: "最終威望", value: respect, symbol: "person.3.fill", color: NoirPalette.red)
                    StatBadge(title: "最終資金", value: money, symbol: "banknote.fill", color: NoirPalette.gold)
                }
                .padding(.horizontal, 20)

                Button(action: restart) {
                    Label("重新洗牌（再玩一次）", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(GoldButtonStyle())
                .padding(.top, 8)
                .padding(.bottom, 36)
            }
            .frame(maxWidth: .infinity)
        }
        .scrollIndicators(.hidden)
    }
}

private struct EndingVisual: View {
    let ending: Ending

    var body: some View {
        Group {
            if ending == .godfather {
                Image("ending_godfather")
                    .resizable()
                    .scaledToFill()
            } else {
                // 之後可在此替換為各結局專屬圖片。
                ZStack {
                    LinearGradient(
                        colors: [.black, NoirPalette.gold.opacity(0.36), NoirPalette.red.opacity(0.38)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    VStack(spacing: 12) {
                        Image(systemName: ending.symbol)
                            .font(.system(size: 58, weight: .bold))
                            .foregroundStyle(NoirPalette.gold)
                        Text(ending.title)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .frame(height: 260)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(NoirPalette.gold, lineWidth: 1.4))
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.5), radius: 18, y: 10)
    }
}

private struct GoldButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.bold))
            .foregroundStyle(NoirPalette.background)
            .padding(.horizontal, 24)
            .padding(.vertical, 15)
            .background(NoirPalette.gold, in: Capsule())
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.82 : 1)
            .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

private struct ChoiceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(NoirPalette.card, in: RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(NoirPalette.gold.opacity(configuration.isPressed ? 1 : 0.56), lineWidth: 1.1))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

private enum NoirPalette {
    static let background = Color(red: 18 / 255, green: 18 / 255, blue: 18 / 255)
    static let card = Color(red: 31 / 255, green: 29 / 255, blue: 25 / 255)
    static let gold = Color(red: 212 / 255, green: 175 / 255, blue: 55 / 255)
    static let red = Color(red: 170 / 255, green: 34 / 255, blue: 35 / 255)
}

#Preview {
    ContentView()
}
