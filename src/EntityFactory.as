package {
	
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import flash.display.BitmapData;
	
	public class EntityFactory {
		
		static public function createResourcedEntity(em:IEntityManager, source:String, id:String, resourceType:Class, e:IEntity = null):IEntity {
			e = e ||= em.create();
			em.addComponent(e, resourceType, {id: id, source: source, toBuild: true});
			return e;
		}
		
		static public function createTextureTile(em:IEntityManager, x:int, y:int, layer:String, source:String, id:String):IEntity {
			var e:IEntity = em.create();
			em.addComponent(e, Transform, {x: x, y: y});
			em.addComponent(e, Layered, {layerId: layer});
			em.addComponent(e, TextureResource, {source: source, id: id});
			return e;
		}
	}
}
