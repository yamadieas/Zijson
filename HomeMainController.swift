
import UIKit
import Alamofire

class HomeMainController: UIViewController {

    private func addContainerV(){
        topBarV.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: 44)
        topBarV.backgroundColor = UIColor.clear
        view.addSubview(topBarV)
        contentContainerV.frame = CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight)
        view.addSubview(contentContainerV)
        setUpTop()
    }
   
    @objc func updateCoinsInfo() {
        topSegView.diamondLab.text = nil //getStringWithNumber(UserModel.share().user?.coins ?? 0)
    }
    /// 从相册选择视频
    func choseVideoFromLibrary() {
        UserModel.share().isPushLF = false
        let storyboard: UIStoryboard = UIStoryboard(name: "Thumbnail", bundle: nil)
        let vc: ThumbnailViewController = storyboard.instantiateViewController(withIdentifier: "Thumbnail") as! ThumbnailViewController
        let nav = CLNavigationController.init(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

//MARK: - 签到业务处理
extension HomeMainController {
    
    func signSuccess(_ sign: SignInfo) {
        signModel = sign
        if let user = sign.user_info {
            UserModel.share().user = user
            updateCoinsInfo()
        }
        if sign.is_first == 1 { // 今日第一次
            let signView = SignAlertView(frame: self.view.bounds)
            view.addSubview(signView)
            signView.setSignShort(sign)
            signView.goDetailHandler = { [weak self] in
                guard let strongSelf = self else { return }
                let vc = DailyInController()
                vc.signModel = strongSelf.signModel
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                signView.removeFromSuperview()
            }
        }
        if let sourcePath = LGConfig.sourceFilePath(LGConfig.kDirectSign) {
            if let images = LGConfig.findFiles(path: sourcePath) {
                if images.count < (sign.sign_ini?.maxday ?? 0) {
                    DLog("signSourceFilePath - fileNumber == \(images.count)")
                    download(signIndex)
                } else {
                    DLog("signSourceFilePath --- \(images.count)")
                }
            }
        }
    }
    func download(_ index: Int) {
        if let signDatas = signModel.sign_ini?.ini, signDatas.count > index {
            if let URL = URL(string: signDatas[index].cover ?? "") {
                downLoadImageDataWith(URL)
            }
        }
    }
    
    /// 下载图片
   func downLoadImageDataWith(_ url: URL) {
    }
}

