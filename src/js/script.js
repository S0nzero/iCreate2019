let renderer, scene, camera, projector;
let models3D = {};

let div = document.getElementById('container');
let raycaster = new THREE.Raycaster(),INTERSECTED;
let mouse = new THREE.Vector2();
var rotationCamera = -0.45;

async function init() {
	renderer = new THREE.WebGLRenderer({antialias: true});
	renderer.setSize(window.innerWidth, window.innerHeight);
	renderer.setClearColor(color.blue, 1);
	renderer.gammaOutput = true;
	renderer.gammaFactor = 2.2;
	div.appendChild(renderer.domElement);

	// Scene, lightning and camera organisationdd
	scene = new THREE.Scene();
	camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 0.2, 25000);
	camera.position.set(0, 200, 50);

	camera.rotation.x = rotationCamera * Math.PI;
	scene.add(camera);
	// TODO: Revoir les parametres des lumiéres
	light = new THREE.PointLight(0xffffff, 1, 4000);
	light.position.set(1000, -1000, 400);
	light_two = new THREE.PointLight(0xffffff, 1, 4000);
	light_two.position.set(-100, 800, 800);
	lightAmbient = new THREE.AmbientLight(0x404040);
	scene.add(light, light_two, lightAmbient);
	await createMap();
	animate();

	// Loading every models
	await loadEveryModels(models_paths, models3D);
	document.addEventListener('keypress', interactionEvent);
	await treeMap(scene, models3D);
	await sleep(1000);
	removeMap(scene, models3D);
	await sleep(50);
	//houseMap(scene, models3D);
	cityMap(scene, models3D);

	renderer.render(scene, camera);
	//document.addEventListener('mousemove', onMouseMove, false);
<<<<<<< HEAD
	await sleep(21000);
	await moveCamera(0,3,150,0,20,100);
=======
	await sleep(14000);
	await moveCamera(0,10,50,-0.1,1,450);
}
async function regionOccupated(x,y,x1,y1){
	for (var  i = x; i<=x1 ;i++) {
		for (var j = y; j<=y1;j++){
			if (isOccupated(i,j)){
				return false;
			}
		}
	}
	return false;
}
async function isOccupated(x,y){
	x = x -10;
	y = y+ 30
	var monImage = new Image();
	monImage.crossOrigin = 'Anonymous';
	if (x + 200>400 && y+200>400){
		console.log("X et Y en dehors des bornes")
	}
	monImage.onload = function()
	{
	  var img = nj.images.read(monImage);
	  var img=nj.images.resize(img,400,400);
	  var gray = nj.images.rgb2gray(img)
	  if (gray.get(x+200,y+200)< 100){
			return true;
		}
		else {
			return false;
		}
	}
	monImage.src=("https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/texture_seuil.jpg");
>>>>>>> bdda2051019eb3536f350ceed977c7d5bf22c9fc
}

async function createMap(){
	texture = new THREE.TextureLoader().load("https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/texture.jpg");
	material = new THREE.MeshBasicMaterial( { map: texture} );
	plane = new THREE.Mesh(new THREE.PlaneGeometry(400, 400), material);
	plane.material.side = THREE.DoubleSide;
	plane.position.x = 10;
	plane.position.z = -30;
	plane.rotation.x = 0.5 * Math.PI;
	scene.add(plane);
}

function interactionEvent(event){
	console.log(event.code)
	if(event.code === 'KeyQ'){
		addHouse();
	} else if (event.code === 'KeyB') {
		addBuilding();
	}
}

function onWindowResize() {
	camera.aspect = window.innerWidth / window.innerHeight;
	renderer.setSize(window.innerWidth, window.innerHeight);
	camera.updateProjectionMatrix();
};

function onMouseMove(event) {
	mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
	mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;
	mouseX = event.clientX - window.innerWidth / 2;
	mouseY = event.clientY - window.innerHeight / 2;
	camera.position.x += (mouseX - camera.position.x) * 0.001;
	camera.position.y += (mouseY - camera.position.y) * 0.001;
	camera.lookAt(scene.position);
};

function animate() {
	requestAnimationFrame(animate);
	renderer.render(scene, camera);
};

init();
