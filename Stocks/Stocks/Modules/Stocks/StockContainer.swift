//
// Created by Иван Лизогуб on 31.01.2021.
//

import UIKit

final class StockContainer {
    let viewController: UIViewController

    static func assemble() -> StockContainer {
        let presenter = StockPresenter()
        let viewController = StockViewController(output: presenter)
        presenter.view = viewController
        return StockContainer(view: viewController)
    }

    private init(view: UIViewController) {
        viewController = view
    }
}
