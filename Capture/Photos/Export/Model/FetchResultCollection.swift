import Photos

final class FetchResultCollection: RandomAccessCollection {
    let includeHiddenAssets: Bool
    let includeBurstAssets: Bool
    let oldestFirst: Bool
    
    private lazy var fetchResult: PHFetchResult<PHAsset> = {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = includeHiddenAssets
        fetchOptions.includeAllBurstAssets = includeBurstAssets
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: oldestFirst)
        ]
        return PHAsset
            .fetchAssets(with: .image, options: fetchOptions)
    }()
    
    init(includeHiddenAssets: Bool = false,
         includeBurstAssets: Bool = false,
         oldestFirst: Bool = false) {
        self.includeHiddenAssets = includeHiddenAssets
        self.includeBurstAssets = includeBurstAssets
        self.oldestFirst = oldestFirst
    }

    var startIndex: Int {
        0
    }
    
    var endIndex: Int {
        fetchResult.count
    }

    subscript(position: Int) -> PHAsset {
        fetchResult.object(at: position)
    }
}
