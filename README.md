## rails_app

<b>rails_app</b> é um projeto Rails com algumas configurações e funcionalidades já implementadas.

## Requerimentos

* Ruby 2.3.0 ou superior
* Rails 5.0.0.1
* [ImageMagick](http://www.imagemagick.org/)
* [Node.js](https://nodejs.org)
* [Gulp.js](http://gulpjs.com/)
* [Bower](http://bower.io/)

## Iniciando

Clonse este repositório:

```shell
  git clone git@github.com:afilhodaniel/rails_app
```

Instale todas as dependências nencessárias

```shell
  sudo npm install

  bower install
```

Rode o Gulp.js:

```shell
  gulp
```

## Restful API

O projeto conta com uma API Restful totalmente funcional e versionada, que pode ser evoluída ou substituída conforme as necessidades do seu projeto. Um modelo de usuário também já está configurado como recurso desta API.

Vale a pena ressaltar que, até o momento, esta API só responde requisições feitas em JSON.

<b>Rotas</b>

Por padrão, apenas os métodos <b>index</b>, <b>show</b>, <b>create</b>, <b>update</b> e <b>destroy</b> estarão disponíveis para qualquer recurso controlado pela API.

Crie novas rotas adicionando e/ou aninhando recursos no seu arquivo <b>config/routes.rb</b>:

```ruby
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update, :destroy]
    end
  end
```

Todas as rotas seguem o padrão abaixo (exceto rotas aninhadas):

* GET /api/v1/users.json
* POST /api/v1/users.json
* GET /api/v1/users/:id.json
* PUT/PATCH /api/v1/users/:id.json
* DELETE /api/v1/users/:id.json
  
<b>Controladores</b>

Crie novos controladores dentro do diretório <b>app/controllers/api/v1</b> e estenda a classe <b>BaseController</b>. Veja o arquivo <b>users_controllers.rb</b> como exemplo:

```ruby
  module Api
    module V1
      class UsersControllers < BaseController
        ...
        private
          def user_params
            ...
          end
          
          def query_params
            ...
          end
      end
    end
  end
```

Todo controlador deve conter o método privado <b><i>resource</i>_params</b> (onde <i>resource</i> é o nome no singular do recurso que está sendo configurado), e também o método privado <b>query_params</b>.

```ruby
  private
    def user_params
      params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
    end
    
    def query_params
      params.permit(:id)
    end
```

Tanto o método <b>user_params</b> como o método <b>query_params</b> são utilizados para permitir parâmetros (strong params) na requisição. O primeiro, para permitir parâmetros no corpo da requisição. O segundo, na URL.

<b>Paginando resultados</b>

Estamos utilizando a gem [kaminari](https://github.com/amatsuda/kaminari) para paginar resultados no método <b>index</b>.

Para paginar resultados, utilize na requisição:

* GET /api/v1/users.json?page=1&page_size=5

E na <i>query</i> da consulta, faça algo como:

```ruby
  User.all.page(params[:page]).per(:page_size)
```

Para mais informações, visite a página do projeto.

<b>Respondendo outros formatos</b>

Esta API só responde requisiões do tipo JSON. Para alterar ou adicionar um novo formato de resposta, altere os métodos <b>index</b>, <b>show</b>, <b>create</b>, <b>update</b> e <b>destroy</b> da classe localizada em <b>app/controllers/api/v1/base_controller.rb</b>

```ruby
  respond_to do |format|
    format.json { render :index }
  end
```

Qualquer requisição de outro formato não configurado, feita a um recurso da API, gerará um erro de formato desconhecido (ActionController::UnknownFormat).

## Sessões de usuário

Além da API Restful, este projeto também conta com um sistema de autenticação baseado em login de usuários. Logo, todos os métodos, tanto da API como de outros controladores herdarão uma ação que força a autenticação do usuário, exceto dois métodos já configurados:

* POST /api/v1/users.json
* GET /

O primeiro não está protegido por autenticação porque é o responsável por permitir a criação de novos usuários dentro da aplicação.

O segundo não está protegido pois se trata da página inicial do projeto.

Você pode alterar esse comportamento conforme desejar, apenas alterando as classes <b>ApplicationController</b> e <b>BaseController</b>, localizadas em <b>app/controllers</b>.

<b>Rotas</b>

Para logar um usuário na sessáo, utilize a rota:

* POST /sessions/signin.json

E monte a requisição dessa maneira:

```ruby
  user: {
    email: "user@sample.com",
    password: "pass123"
  }
```

Para deslogar um usuário da sessão, utilize a rota:
* GET /sessions/signout

<b>Usuário atual da sessão</b>

Em qualquer controlador ou view que herde direta ou indiretamente a classe <b>ApplicationController</b>, você tem a variável de instância <b>@current_user</b>, que contém todas as informações do usuário atual da sessão.
