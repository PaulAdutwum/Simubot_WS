from setuptools import find_packages, setup

package_name = 'simubot_vision'

setup(
    name=package_name,
    version='0.0.0',
    # 1) Automatically find all packages in the simubot_vision/ directory,
    #    excluding the test/ folder.
    packages=find_packages(exclude=['test']),
    data_files=[
        # 2) Install the package.xml file into share/simubot_vision
        ('share/' + package_name, ['package.xml']),
        # 3) Register this package for the ament index (resource marker)
        ('share/ament_index/resource_index/packages', ['resource/' + package_name]),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='Your Name',               # Replace with your name if you like
    maintainer_email='you@example.com',   # Replace with your email if you like
    description='SimuBotVision: a ROS2 Python node for object detection',
    license='Apache License 2.0',         # Replace if needed
    tests_require=['pytest'],
    entry_points={
        # 4) This creates the executable script:
        #    install/lib/simubot_vision/vision_node
        'console_scripts': [
            'vision_node = simubot_vision.vision_node:main'
        ],
    },
)