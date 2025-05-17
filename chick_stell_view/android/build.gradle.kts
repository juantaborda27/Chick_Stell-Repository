buildscript {
    repositories {
        google()           // ✅ NECESARIO
        mavenCentral()     // ✅ NECESARIO
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir) // Cambiado de value() a set()

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir) // Cambiado de value() a set()
}
subprojects {
    project.evaluationDependsOn(":app")
    
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
