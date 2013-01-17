# The Linux Alternative Project

This is code that generates the website, The Linux Alternative Project
(http://www.linuxalt.com).

## Contributing

### \_data/linux\_alternatives.yaml

Help keep the **alternatives tables** current and relevant!  The YAML
encoded data file is found in the \_data directory.  This is the heart
of the project and is used to generate the site.

Each list element is considered a "category".

    - category:
         name: 3D Home Modeling
         internal_link: 3d-home-modeling.html
      linux_alternatives:
         Sweet Home 3D: 
             internal_link: Sweet_Home_3D.html
             url: http://sweethome3d.sourceforge.net/index.html
      windows_software:
         3D Home Architect:
             internal_link: 3d_home_architect.html
      meta: &3DHomeModelingCat

The **category** key above is currently not used, but it illustrates how
the file is layed out.  Each program should be listed under either
*linux_alternatives* or *windows_software* as appropriate and follow the
style shown above.
