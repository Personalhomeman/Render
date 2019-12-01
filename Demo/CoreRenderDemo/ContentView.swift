import SwiftUI
import CoreRender
import Render

extension Context {
  /// The context used for SwiftUI bridged views.
  public static let swiftUISharedContext = Context()
}

public struct CoreRenderBridgeView: UIViewRepresentable {
  /// The node hiearchy.
  public let buildBlock: (Context) -> OpaqueNodeBuilderConvertible

  public init(_ buildBlock: @escaping (Context) -> OpaqueNodeBuilderConvertible) {
    self.buildBlock = buildBlock
  }

  public func makeUIView(context: UIViewRepresentableContext<CoreRenderBridgeView>) -> HostingView {
    let hostingView = HostingView(context: CoreRender.Context.swiftUISharedContext, with: []) {
      context in self.buildBlock(context).builder()
    }
    return hostingView
  }

  public func updateUIView(
    _ uiView: HostingView,
    context: UIViewRepresentableContext<CoreRenderBridgeView>
  ) -> Void {
    uiView.setNeedsReconcile()
  }
}

struct ContentView: View {
    var body: some View {
      VStack {
        Text("Hello World")
        CoreRenderBridgeView { context in
          VStackNode {
            LabelNode(text: "Hello World")
            EmptyNode()
          }
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
