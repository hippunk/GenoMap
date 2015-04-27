package managers {
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.core.logic.impl.LogicScope;
	import components.Case;
	
	public class CaseManager extends LogicScope {
		
		[Inject] public var entityManager:IEntityManager;
		[Inject] public var geneManager:GeneManager;
		private var caseEntities:Family;
		private var caseMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			caseEntities = entityManager.getFamily(allOfGenes(Case));
			caseMapper = geneManager.getComponentMapper(Case);
			
			//On force l'ajout des cases
			caseEntities.entityAdded.add(ajout);
		}
		
		protected function ajout(e:IEntity):void {
			trace("chargement d'une case forcé");
		}
	}
}