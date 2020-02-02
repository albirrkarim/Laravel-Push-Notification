@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">Dashboard</div>

                <div class="card-body">
                    @if (session('status'))
                        <div class="alert alert-success" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif

                    <div id="notif" class="alert alert-primary alert-block collapse">
                        <button type="button" class="close" data-dismiss="alert">×</button>	
                        <strong id="notifMsg"></strong>
                    </div>
                    <div class="container">
                        
                        <button onclick="NOTIF.subscribe()" class="btn btn-success">Subscribe Notification</button>
                        <button onclick="NOTIF.unsubscribe()" class="btn btn-danger">UnSubscribeNotification</button>
                    </div>
                    <div class="container">
                        <button onclick="NOTIF.sendNotification()" class="btn btn-primary">Send Notification</button>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
