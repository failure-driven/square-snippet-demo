<div class="input-wrapper">
  <input>
  <button>></button>
</div>

<style>
  input {
    flex-grow: 1;
    width: 90%;
    height: 100%;
    border-top-left-radius: 10px;
    border-bottom-left-radius: 10px;
    margin-right: -6px;
  }
  input:focus {
    outline: none;
  }
  button {
    width: 10%;
    height: 100%;
    border-top-right-radius: 10px;
    border-bottom-right-radius: 10px;
  }
  button:focus {
    outline: none;
  }
  .input-wrapper {
    display: flex;
    flex-grow: 1;
    height: 100%;
  }
</style>