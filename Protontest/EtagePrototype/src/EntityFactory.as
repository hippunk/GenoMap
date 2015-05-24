package {
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.core.entity.impl.EntityManager;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.resource.component.TextureResource;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.logic.system.System;	
	import components.Level;
	import components.TypeCase;
	
	public class EntityFactory {
		static public function createResourcedEntity(em:IEntityManager, source:String, id:String, resourceType:Class, e:IEntity = null):IEntity {
			e = e ||= em.create();
			em.addComponent(e, resourceType, {id:id,source:source,toBuild:true } );
			return e;
		}
		
		static public function createSquare(em:IEntityManager, x:int, y:int,decX:int,decY:int,level:int, layer:String, tex:TextureResource):IEntity {
			var e:IEntity = em.create();
			
			
			//trace("Dans createSquare, type : " + type);
			//trace("test : " + (type == "Wall"));		

			
			em.addComponent(e, Transform, { x:x+decX, y:y+decY } );
			em.addComponent(e, Layered, { layerId:layer} );
			em.addComponent(e, TextureResource, tex );
			em.addComponent(e, Level, { level:level } );
			return e;
		}	
	}	
}