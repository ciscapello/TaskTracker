//
//  MainViewController.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Realm
import RealmSwift
import RxDataSources
import RxRealm

class MainViewController: UIViewController {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Task>? = nil
    
    var viewModel: MainViewModelProtocol?
    
    var disposeBag = DisposeBag()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("Path to realm file: " + realm.configuration.fileURL!.absoluteString)
        viewModel = MainViewModel()
        view.backgroundColor = UIColor.init(named: Colors.background.rawValue)
        title = "Все списки"
        view.addSubview(collectionView)
        collectionView.delegate = self
        setup()
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = UIColor(named: Colors.background.rawValue)
        createDataSource()
        reloadData()
        let sections = realm.objects(Section.self)
        Observable.collection(from: sections).subscribe { event in
            print(event)
            self.reloadData()
        }.disposed(by: disposeBag)
    }
    
    func setup () {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Новый список", style: .plain, target: self, action: #selector(didTapCreateCategoryButton))
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        collectionView.register(ColumnTaskCell.self, forCellWithReuseIdentifier: ColumnTaskCell.identifier)
        collectionView.register(TableTaskCell.self, forCellWithReuseIdentifier: TableTaskCell.identifier)
        collectionView.register(RowTaskCell.self, forCellWithReuseIdentifier: RowTaskCell.identifier)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
    }
    
    func createDataSource () {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, task in
            switch self.viewModel!.sections?[indexPath.section].type {
            case .row: return self.configureCell(cellType: RowTaskCell.self, with: task, for: indexPath)
            case .table: return self.configureCell(cellType: TableTaskCell.self, with: task, for: indexPath)
            default:
                return self.configureCell(cellType: ColumnTaskCell.self, with: task, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as! SectionHeader
                                
            let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section]

            sectionHeader.title.text = section!.title
            sectionHeader.subtitle.text = section!.subtitle
            sectionHeader.button.category = section!.title
            sectionHeader.button.categoryId = section!.id
            sectionHeader.button.addTarget(self, action: #selector(self?.didSelectButtonInHeader(sender:)), for: .touchUpInside)
            return sectionHeader
        }
    }
    
    private func createLayout () -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch self.viewModel?.sections?[sectionIndex].type {
                case .columns: return self.createColumnSection(sectionIndex)
                case .table: return self.createTableSection(sectionIndex)
                default: return self.createRowSection(sectionIndex)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    private func reloadData () {
        guard let viewModel, let sections = viewModel.sections else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.tasks.toArray(), toSection: section)
        }
//        dataSource?.apply(snapshot, animatingDifferences: true)
        
        dataSource?.applySnapshotUsingReloadData(snapshot)
        
    }
    
    
    private func configureCell<T: ConfiguringCell>(cellType: T.Type, with task: Task, for indexPath: IndexPath) -> T {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
        cell.configure(with: task)
        return cell
    }
    
    @objc func didSelectButtonInHeader (sender: UIHeaderButton) {
        viewModel?.createTaskDidPressed(with: sender.category!, categoryId: sender.categoryId!, from: self)
    }
    
    @objc func didTapCreateCategoryButton () {
        viewModel?.createCategoryDidPressed(from: self)
    }
}

//MARK: - Create sections

extension MainViewController {
    
    private func createTableSection (_ sectionIndex: Int) -> NSCollectionLayoutSection {
        let taskCount = viewModel?.sections?[sectionIndex].tasks.toArray().count
        var groupCoefficient = 0.0
        var itemCoefficient = 0.0
        switch taskCount {
        case 0: groupCoefficient = 0; itemCoefficient = 0
        case 1: groupCoefficient = 0.13; itemCoefficient = 1
        case 2: groupCoefficient = 0.26; itemCoefficient = 1/2
        default: groupCoefficient = 0.4; itemCoefficient = 1/3
        }
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(itemCoefficient))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(0), top: .flexible(0), trailing: .flexible(0), bottom: .flexible(0))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(groupCoefficient))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createColumnSection (_ sectionIndex: Int) -> NSCollectionLayoutSection {
        let isEmpty = viewModel?.sections?[sectionIndex].tasks.isEmpty
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(isEmpty! ? 0 : 1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createRowSection (_ sectionIndex: Int) -> NSCollectionLayoutSection {
        let isEmpty = viewModel?.sections?[sectionIndex].tasks.isEmpty
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(isEmpty! ? 0 : 1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createSectionHeader () -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }
    
}


extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = viewModel?.sections?[indexPath.section] else { return }
        let item = section.tasks[indexPath.row] as Task
        viewModel?.taskDidPressed(with: item, from: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPaths.isEmpty { return nil }
        let deleteCancel = UIAction(title: "Отмена", image: UIImage(systemName: "xmark")) { action in }
        let deleteConfirmation = UIAction(title: "Да, удалить", image: UIImage(systemName: "checkmark"), attributes: .destructive) { action in self.viewModel?.deleteTaskByIndexPath(indexPaths[0])}
        let delete = UIMenu(title: "Удалить", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])
        let mainMenu = UIMenu(title: "", children: [delete])

        return UIContextMenuConfiguration(actionProvider:  { menuElement in
            return mainMenu
        })
    }
}

